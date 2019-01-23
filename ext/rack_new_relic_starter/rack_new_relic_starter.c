#include <errno.h>
#include <sys/mman.h>
#include <unistd.h>
#include "rack_new_relic_starter.h"

VALUE eError;

static void
latch_free(void *ptr)
{
    munmap(ptr, 1);
}

static size_t
latch_size(const void *ptr)
{
    return sysconf(_SC_PAGE_SIZE);
}

static const rb_data_type_t latch_data_type = {
    "latch",
    { NULL, latch_free, latch_size, },
    0, 0, RUBY_TYPED_FREE_IMMEDIATELY
};

static VALUE
latch_s_allocate(VALUE klass)
{
    return TypedData_Wrap_Struct(klass, &latch_data_type, 0);
}

/*
 * call-seq:
 *    Rack::NewRelic::Starter::Latch.new -> latch
 *
 * Returns a new {Latch} object.
 *
 *    Rack::NewRelic::Starter::Latch.new #=> #<Rack::NewRelic::Starter::Latch:0x00007f9a2db15890>
 */
static VALUE
latch_initialize(VALUE self)
{
    void *addr = mmap(NULL, 1, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_SHARED, -1, 0);
    if (addr == MAP_FAILED) {
        rb_raise(eError, "failed to create mapping for latch: %s", strerror(errno));
    }

    DATA_PTR(self) = addr;

    return self;
}

static inline uint8_t *
check_latch(VALUE self)
{
      return rb_check_typeddata(self, &latch_data_type);
}

/*
 * call-seq:
 *    latch.open! -> nil
 *
 * Opens the latch.
 *
 *    latch = Rack::NewRelic::Starter::Latch.new
 *    latch.opened? #=> false
 *    latch.open!
 *    latch.opened? #=> true
 */
static VALUE
latch_open(VALUE self)
{
    uint8_t *l = check_latch(self);
    *l = 1;
    return Qnil;
}

/*
 * call-seq:
 *    latch.opened? -> boolean
 *
 * Returns true if the latch is opened.
 *
 *    latch = Rack::NewRelic::Starter::Latch.new
 *    latch.opened? #=> false
 *    latch.open!
 *    latch.opened? #=> true
 */
static VALUE
latch_opened(VALUE self)
{
    return *check_latch(self) == 1 ? Qtrue : Qfalse;
}

void
Init_rack_new_relic_starter(void)
{
    VALUE mRack, mNewRelic, cStarter, cLatch;

    mRack = rb_define_module("Rack");
    mNewRelic = rb_define_module_under(mRack, "NewRelic");
    cStarter = rb_define_class_under(mNewRelic, "Starter", rb_cObject);
    eError = rb_define_class_under(cStarter, "Error", rb_eStandardError);

    /*
     * Document-class: Rack::NewRelic::Starter::Latch
     *
     * Rack::NewRelic::Starter::Latch is an object to indicate that the New
     * Relic agent should be started.
     */
    cLatch = rb_define_class_under(cStarter, "Latch", rb_cObject);
    rb_define_alloc_func(cLatch, latch_s_allocate);
    rb_define_method(cLatch, "initialize", latch_initialize, 0);
    rb_define_method(cLatch, "open!", latch_open, 0);
    rb_define_method(cLatch, "opened?", latch_opened, 0);
}
