from libc.stdint cimport uint8_t

cdef extern from "libavutil/buffer.h" nogil:

    ctypedef struct AVBuffer:
        pass

    cdef struct AVBufferRef:
        AVBuffer *buffer
        uint8_t *data
        int      size

    cdef AVBufferRef *av_buffer_alloc(int size)

    cdef AVBufferRef *av_buffer_allocz(int size)

    cdef AVBufferRef *av_buffer_create(uint8_t *data, int size,
                                       void (*free)(void *opaque, uint8_t *data),
                                       void *opaque, int flags)

    cdef void av_buffer_default_free(void *opaque, uint8_t *data)

    cdef AVBufferRef *av_buffer_ref(AVBufferRef *buf)

    cdef void av_buffer_unref(AVBufferRef **buf)

    cdef int av_buffer_is_writable(const AVBufferRef *buf)

    cdef void *av_buffer_get_opaque(const AVBufferRef *buf)

    cdef int av_buffer_get_ref_count(const AVBufferRef *buf)

    cdef int av_buffer_make_writable(AVBufferRef **buf)

    cdef int av_buffer_realloc(AVBufferRef **buf, int size)

    ctypedef struct AVBufferPool

    cdef AVBufferPool *av_buffer_pool_init(int size, AVBufferRef* (*alloc)(int size))

    cdef AVBufferPool *av_buffer_pool_init2(int size, void *opaque,
                                            AVBufferRef* (*alloc)(void *opaque, int size),
                                            void (*pool_free)(void *opaque))

    cdef void av_buffer_pool_uninit(AVBufferPool **pool)

    cdef AVBufferRef *av_buffer_pool_get(AVBufferPool *pool)


cdef extern from "libavutil/hwcontext.h" nogil:

    cdef enum AVHWDeviceType:
        AV_HWDEVICE_TYPE_NONE
        AV_HWDEVICE_TYPE_VDPAU
        AV_HWDEVICE_TYPE_CUDA
        AV_HWDEVICE_TYPE_VAAPI
        AV_HWDEVICE_TYPE_DXVA2
        AV_HWDEVICE_TYPE_QSV
        AV_HWDEVICE_TYPE_VIDEOTOOLBOX
        AV_HWDEVICE_TYPE_D3D11VA
        AV_HWDEVICE_TYPE_DRM
        AV_HWDEVICE_TYPE_OPENCL
        AV_HWDEVICE_TYPE_MEDIACODEC

    ctypedef struct AVHWDeviceInternal:
        pass

    ctypedef struct AVHWDeviceContext:
        AVClass *av_class
        AVHWDeviceInternal *internal
        AVHWDeviceType type
        void *hwctx
        void (*free)(AVHWDeviceContext *ctx)
        void *user_opaque

    ctypedef struct AVHWFramesInternal:
        pass

    ctypedef struct AVHWFramesContext:
        const AVClass *av_class
        AVHWFramesInternal *internal
        AVBufferRef *device_ref
        AVHWDeviceContext *device_ctx
        void *hwctx
        void (*free)(AVHWFramesContext *ctx)
        void *user_opaque
        AVBufferPool *pool
        int initial_pool_size
        AVPixelFormat format
        AVPixelFormat sw_format
        int width
        int height

    cdef AVHWDeviceType av_hwdevice_find_type_by_name(const char *name)

    cdef const char *av_hwdevice_get_type_name(AVHWDeviceType type)

    cdef AVHWDeviceType av_hwdevice_iterate_types(AVHWDeviceType prev)

    cdef AVBufferRef *av_hwdevice_ctx_alloc(AVHWDeviceType type);

    cdef int av_hwdevice_ctx_init(AVBufferRef *ref)

    cdef int av_hwdevice_ctx_create(AVBufferRef **device_ctx, AVHWDeviceType type,
                                    const char *device, AVDictionary *opts, int flags)

    cdef int av_hwdevice_ctx_create_derived(AVBufferRef **dst_ctx,
                                            AVHWDeviceType type,
                                            AVBufferRef *src_ctx, int flags)

    cdef AVBufferRef *av_hwframe_ctx_alloc(AVBufferRef *device_ctx)

    cdef int av_hwframe_ctx_init(AVBufferRef *ref)

    cdef int av_hwframe_get_buffer(AVBufferRef *hwframe_ctx, AVFrame *frame, int flags)

    cdef int av_hwframe_transfer_data(AVFrame *dst, const AVFrame *src, int flags)

    enum AVHWFrameTransferDirection:
        AV_HWFRAME_TRANSFER_DIRECTION_FROM
        AV_HWFRAME_TRANSFER_DIRECTION_TO
    
    cdef int av_hwframe_transfer_get_formats(AVBufferRef *hwframe_ctx,
                                             AVHWFrameTransferDirection dir,
                                             AVPixelFormat **formats, int flags)

    ctypedef struct AVHWFramesConstraints:
        AVPixelFormat *valid_hw_formats

        AVPixelFormat *valid_sw_formats

        int min_width
        int min_height

        int max_width
        int max_height

    cdef void *av_hwdevice_hwconfig_alloc(AVBufferRef *device_ctx)

    cdef AVHWFramesConstraints *av_hwdevice_get_hwframe_constraints(AVBufferRef *ref,
                                                                    const void *hwconfig)

    cdef void av_hwframe_constraints_free(AVHWFramesConstraints **constraints)

    cdef enum:
        AV_HWFRAME_MAP_READ
        AV_HWFRAME_MAP_WRITE
        AV_HWFRAME_MAP_OVERWRITE
        AV_HWFRAME_MAP_DIRECT

    cdef int av_hwframe_map(AVFrame *dst, const AVFrame *src, int flags)

    cdef int av_hwframe_ctx_create_derived(AVBufferRef **derived_frame_ctx,
                                           AVPixelFormat format,
                                           AVBufferRef *derived_device_ctx,
                                           AVBufferRef *source_frame_ctx,
                                           int flags)

