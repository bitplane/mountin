#include <kernel.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdint.h>
#include <swis.h>

int errno;

int __ul_seterr(const _kernel_oserror *error, int value)
{
    (void) error;
    errno = value;
    return -1;
}

static void write_character(char character)
{
    _swix(OS_WriteC, _IN(0), (unsigned char) character);
}

int putchar(int character)
{
    write_character((char) character);
    return (unsigned char) character;
}

int puts(const char *string)
{
    while (*string != '\0')
        write_character(*string++);
    write_character('\n');
    return 0;
}

unsigned long strtoul(const char *string, char **end, int base)
{
    const char *cursor = string;
    unsigned long value = 0;
    int digit;
    while (*cursor == ' ' || *cursor == '\t')
        ++cursor;
    if (*cursor == '+')
        ++cursor;
    if ((base == 0 || base == 16) && cursor[0] == '0' &&
            (cursor[1] == 'x' || cursor[1] == 'X')) {
        base = 16;
        cursor += 2;
    } else if (base == 0) {
        base = *cursor == '0' ? 8 : 10;
    }
    for (;;) {
        if (*cursor >= '0' && *cursor <= '9')
            digit = *cursor - '0';
        else if (*cursor >= 'a' && *cursor <= 'z')
            digit = *cursor - 'a' + 10;
        else if (*cursor >= 'A' && *cursor <= 'Z')
            digit = *cursor - 'A' + 10;
        else
            break;
        if (digit >= base)
            break;
        value = value * (unsigned) base + (unsigned) digit;
        ++cursor;
    }
    if (end != NULL)
        *end = (char *) cursor;
    return value;
}

void *malloc(size_t size)
{
    void *block = NULL;
    if (size != 0 && _swix(OS_Module, _INR(0, 1) | _OUT(2),
            6, size, &block) == NULL)
        return block;
    return NULL;
}

void free(void *block)
{
    if (block != NULL)
        _swix(OS_Module, _IN(0) | _IN(2), 7, block);
}

static void append_character(char **output, size_t *remaining,
    int *length, char character)
{
    if (*remaining > 1) {
        **output = character;
        ++*output;
        --*remaining;
    }
    ++*length;
}

static void append_unsigned(char **output, size_t *remaining, int *length,
    unsigned long value, unsigned base, int uppercase, int width, char pad)
{
    char digits[32];
    int count = 0;
    do {
        unsigned digit = value % base;
        digits[count++] = digit < 10 ? (char) ('0' + digit) :
            (char) ((uppercase ? 'A' : 'a') + digit - 10);
        value /= base;
    } while (value != 0);
    while (count < width)
        digits[count++] = pad;
    while (count != 0)
        append_character(output, remaining, length, digits[--count]);
}

static int format_text(char *buffer, size_t size, const char *format_string,
    va_list arguments)
{
    char *output = buffer;
    size_t remaining = size;
    int length = 0;
    while (*format_string != '\0') {
        int width = 0;
        char pad = ' ';
        char conversion;
        if (*format_string != '%') {
            append_character(&output, &remaining, &length, *format_string++);
            continue;
        }
        ++format_string;
        if (*format_string == '%') {
            append_character(&output, &remaining, &length, *format_string++);
            continue;
        }
        if (*format_string == '0') {
            pad = '0';
            ++format_string;
        }
        while (*format_string >= '0' && *format_string <= '9') {
            width = width * 10 + *format_string - '0';
            ++format_string;
        }
        if (*format_string == '.') {
            ++format_string;
            while (*format_string >= '0' && *format_string <= '9')
                ++format_string;
        }
        conversion = *format_string++;
        if (conversion == 's') {
            const char *string = va_arg(arguments, const char *);
            while (*string != '\0')
                append_character(&output, &remaining, &length, *string++);
        } else if (conversion == 'c') {
            append_character(&output, &remaining, &length,
                (char) va_arg(arguments, int));
        } else if (conversion == 'd' || conversion == 'i') {
            long value = va_arg(arguments, int);
            if (value < 0) {
                append_character(&output, &remaining, &length, '-');
                value = -value;
            }
            append_unsigned(&output, &remaining, &length,
                (unsigned long) value, 10, 0, width, pad);
        } else if (conversion == 'u') {
            append_unsigned(&output, &remaining, &length,
                va_arg(arguments, unsigned), 10, 0, width, pad);
        } else if (conversion == 'x' || conversion == 'X' || conversion == 'p') {
            unsigned long value = conversion == 'p' ?
                (uintptr_t) va_arg(arguments, void *) :
                va_arg(arguments, unsigned);
            append_unsigned(&output, &remaining, &length, value, 16,
                conversion == 'X', width, pad);
        }
    }
    if (remaining != 0)
        *output = '\0';
    return length;
}

int snprintf(char *buffer, size_t size, const char *format_string, ...)
{
    va_list arguments;
    int length;
    va_start(arguments, format_string);
    length = format_text(buffer, size, format_string, arguments);
    va_end(arguments);
    return length;
}

int sprintf(char *buffer, const char *format_string, ...)
{
    va_list arguments;
    int length;
    va_start(arguments, format_string);
    length = format_text(buffer, (size_t) -1, format_string, arguments);
    va_end(arguments);
    return length;
}

int printf(const char *format_string, ...)
{
    char buffer[512];
    va_list arguments;
    int length;
    int index;
    va_start(arguments, format_string);
    length = format_text(buffer, sizeof buffer, format_string, arguments);
    va_end(arguments);
    for (index = 0; buffer[index] != '\0'; ++index)
        write_character(buffer[index]);
    return length;
}

int _kernel_irqs_disabled(void)
{
    unsigned status;
    __asm__ volatile ("mrs %0, cpsr" : "=r" (status));
    return (status & (1u << 7)) != 0;
}

void _kernel_irqs_off(void)
{
    __asm__ volatile ("cpsid i" ::: "memory", "cc");
}

void _kernel_irqs_on(void)
{
    __asm__ volatile ("cpsie i" ::: "memory", "cc");
}

_kernel_stack_chunk *_kernel_current_stack_chunk(void)
{
    uintptr_t stack_limit;
    __asm__ volatile ("mov %0, r10" : "=r" (stack_limit));
    return (_kernel_stack_chunk *) (stack_limit - 560);
}
