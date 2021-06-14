Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4A33A5DFF
	for <lists+kvm-ppc@lfdr.de>; Mon, 14 Jun 2021 09:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbhFNIAl (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 14 Jun 2021 04:00:41 -0400
Received: from mail-oi1-f174.google.com ([209.85.167.174]:34639 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbhFNIAl (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 14 Jun 2021 04:00:41 -0400
Received: by mail-oi1-f174.google.com with SMTP id u11so13477843oiv.1
        for <kvm-ppc@vger.kernel.org>; Mon, 14 Jun 2021 00:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yq6AnfCSSGBKIjj0YUKAQhUo7JvGmmvBuQXaLpyD50c=;
        b=XG+FKxmfcX5Krd+wIYJAOJoEAWGt7/+MF5rP5R9m2fDAOoDqN0bp1FI4ZBUxKjT94g
         JOFOq6f8O/MH4bjUOFM/HsKKw8lt2xDloBBqnhsxMiFH7BgC104XADMYjavu8Oup4LfR
         jgOigas1ZFTjt9q08NEOSVzlwtG64oK84LVMHeY+LhTboYum8BN5sCyOdSGxmORa+HjT
         0Kp+XpFY030W3lQLTJn+XHETgjud/jARd8OzJUALsnLrwe4yGHKJoJKDEeStFESCJUWO
         e9Bx1xfCBodSDdwymUkwEqonPH/2P04s1JHSmEL7bvEdY0wiFNt6/NKLg3HEYHV0pFvw
         Xf3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yq6AnfCSSGBKIjj0YUKAQhUo7JvGmmvBuQXaLpyD50c=;
        b=ibWfsadxqXq94CtGkL+8hB/NRXaL57b3hjQv3jbOR2f+A3JMxdPCUwCAhtBjnZ5kp0
         LAUKP/F90AI8PjecEGq8grap8BFVr4RjddrtE5em0LuHIA7CFwO2nYM+guDwiCJ873Ak
         YO7SvTSMjMYvONejh0W1xDtcbn68lB6coS5qo8hv4qDDSDSTS5TpvkOIj0TGDv10J05s
         BjgvN4d3m8EH1LjM4ePI2dHLR3DyJ06039mzVAiib5i8kkJrnp+al718ON520CEq3fz7
         8dS+15wALMeJ6ypZU3Uh/nEV2L0xn18/xWr71YIS8KJO4vsTVU+IKcxgFQiJHdec5Nny
         Ca1g==
X-Gm-Message-State: AOAM5338xFfRoFAPgc+5LALWvHGw/AXyVTSt7QrW6YDFxJ4R79g2dKNM
        VVxpp3v95gra/d9NsixlVpc9zY9AOKnIuI9syGFwew==
X-Google-Smtp-Source: ABdhPJxXbh3raDmzdNtJDlVZIjrXxst6G4uF4DHsOU1jnE1vIsaJzRI1vd/bW3K4lBCJONGuzpQ3gE6UIVFo/t0pyEc=
X-Received: by 2002:aca:b38a:: with SMTP id c132mr4604810oif.90.1623657449654;
 Mon, 14 Jun 2021 00:57:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210603211426.790093-1-jingzhangos@google.com> <20210603211426.790093-4-jingzhangos@google.com>
In-Reply-To: <20210603211426.790093-4-jingzhangos@google.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 14 Jun 2021 08:56:53 +0100
Message-ID: <CA+EHjTxeZOAPA9w6UJe7rW+-UdznrEsNmomWodZDN3DLgLoJKA@mail.gmail.com>
Subject: Re: [PATCH v7 3/4] KVM: stats: Add documentation for statistics data
 binary interface
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Jing,


On Thu, Jun 3, 2021 at 10:14 PM Jing Zhang <jingzhangos@google.com> wrote:
>
> Update KVM API documentation for binary statistics.
>
> Reviewed-by: David Matlack <dmatlack@google.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 180 +++++++++++++++++++++++++++++++++
>  1 file changed, 180 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 7fcb2fd38f42..550bfbdf611b 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5034,6 +5034,178 @@ see KVM_XEN_VCPU_SET_ATTR above.
>  The KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST type may not be used
>  with the KVM_XEN_VCPU_GET_ATTR ioctl.
>
> +4.130 KVM_GET_STATS_FD
> +---------------------

nit: missing one - (to match the subtitle length)

> +
> +:Capability: KVM_CAP_STATS_BINARY_FD
> +:Architectures: all
> +:Type: vm ioctl, vcpu ioctl
> +:Parameters: none
> +:Returns: statistics file descriptor on success, < 0 on error
> +
> +Errors:
> +
> +  ======     ======================================================
> +  ENOMEM     if the fd could not be created due to lack of memory
> +  EMFILE     if the number of opened files exceeds the limit
> +  ======     ======================================================
> +
> +The file descriptor can be used to read VM/vCPU statistics data in binary
> +format. The file data is organized into three blocks as below:
> ++-------------+
> +|   Header    |
> ++-------------+
> +| Descriptors |
> ++-------------+
> +| Stats Data  |
> ++-------------+
> +
> +The Header block is always at the start of the file. It is only needed to be
> +read one time for the lifetime of the file descriptor.
> +It is in the form of ``struct kvm_stats_header`` as below::
> +
> +       #define KVM_STATS_ID_MAXLEN             64
> +
> +       struct kvm_stats_header {
> +               char id[KVM_STATS_ID_MAXLEN];
> +               __u32 name_size;
> +               __u32 count;
> +               __u32 desc_offset;
> +               __u32 data_offset;
> +       };
> +
> +The ``id`` field is identification for the corresponding KVM statistics. For
> +VM statistics, it is in the form of "kvm-{kvm pid}", like "kvm-12345". For
> +VCPU statistics, it is in the form of "kvm-{kvm pid}/vcpu-{vcpu id}", like
> +"kvm-12345/vcpu-12".
> +
> +The ``name_size`` field is the size (byte) of the statistics name string
> +(including trailing '\0') appended to the end of every statistics descriptor.
> +
> +The ``count`` field is the number of statistics.
> +
> +The ``desc_offset`` field is the offset of the Descriptors block from the start
> +of the file indicated by the file descriptor.
> +
> +The ``data_offset`` field is the offset of the Stats Data block from the start
> +of the file indicated by the file descriptor.
> +
> +The Descriptors block is only needed to be read once for the lifetime of the
> +file descriptor. It is an array of ``struct kvm_stats_desc`` as shown in
> +below code block::
> +
> +       #define KVM_STATS_TYPE_SHIFT            0
> +       #define KVM_STATS_TYPE_MASK             (0xF << KVM_STATS_TYPE_SHIFT)
> +       #define KVM_STATS_TYPE_CUMULATIVE       (0x0 << KVM_STATS_TYPE_SHIFT)
> +       #define KVM_STATS_TYPE_INSTANT          (0x1 << KVM_STATS_TYPE_SHIFT)
> +       #define KVM_STATS_TYPE_MAX              KVM_STATS_TYPE_INSTANT
> +
> +       #define KVM_STATS_UNIT_SHIFT            4
> +       #define KVM_STATS_UNIT_MASK             (0xF << KVM_STATS_UNIT_SHIFT)
> +       #define KVM_STATS_UNIT_NONE             (0x0 << KVM_STATS_UNIT_SHIFT)
> +       #define KVM_STATS_UNIT_BYTES            (0x1 << KVM_STATS_UNIT_SHIFT)
> +       #define KVM_STATS_UNIT_SECONDS          (0x2 << KVM_STATS_UNIT_SHIFT)
> +       #define KVM_STATS_UNIT_CYCLES           (0x3 << KVM_STATS_UNIT_SHIFT)
> +       #define KVM_STATS_UNIT_MAX              KVM_STATS_UNIT_CYCLES
> +
> +       #define KVM_STATS_BASE_SHIFT            8
> +       #define KVM_STATS_BASE_MASK             (0xF << KVM_STATS_BASE_SHIFT)
> +       #define KVM_STATS_BASE_POW10            (0x0 << KVM_STATS_BASE_SHIFT)
> +       #define KVM_STATS_BASE_POW2             (0x1 << KVM_STATS_BASE_SHIFT)
> +       #define KVM_STATS_BASE_MAX              KVM_STATS_BASE_POW2
> +
> +       struct kvm_stats_desc {
> +               __u32 flags;
> +               __s16 exponent;
> +               __u16 size;
> +               __u32 unused1;
> +               __u32 unused2;
> +               char name[0];
> +       };
> +
> +The ``flags`` field contains the type and unit of the statistics data described
> +by this descriptor. The following flags are supported:
> +
> +Bits 0-3 of ``flags`` encode the type:
> +  * ``KVM_STATS_TYPE_CUMULATIVE``
> +    The statistics data is cumulative. The value of data can only be increased.
> +    Most of the counters used in KVM are of this type.
> +    The corresponding ``count`` filed for this type is always 1.

filed -> field

> +  * ``KVM_STATS_TYPE_INSTANT``
> +    The statistics data is instantaneous. Its value can be increased or
> +    decreased. This type is usually used as a measurement of some resources,
> +    like the number of dirty pages, the number of large pages, etc.
> +    The corresponding ``count`` field for this type is always 1.
> +
> +Bits 4-7 of ``flags`` encode the unit:
> +  * ``KVM_STATS_UNIT_NONE``
> +    There is no unit for the value of statistics data. This usually means that
> +    the value is a simple counter of an event.
> +  * ``KVM_STATS_UNIT_BYTES``
> +    It indicates that the statistics data is used to measure memory size, in the
> +    unit of Byte, KiByte, MiByte, GiByte, etc. The unit of the data is
> +    determined by the ``exponent`` field in the descriptor. The
> +    ``KVM_STATS_BASE_POW2`` flag is valid in this case. The unit of the data is
> +    determined by ``pow(2, exponent)``. For example, if value is 10,
> +    ``exponent`` is 20, which means the unit of statistics data is MiByte, we
> +    can get the statistics data in the unit of Byte by
> +    ``value * pow(2, exponent) = 10 * pow(2, 20) = 10 MiByte`` which is
> +    10 * 1024 * 1024 Bytes.
> +  * ``KVM_STATS_UNIT_SECONDS``
> +    It indicates that the statistics data is used to measure time/latency, in
> +    the unit of nanosecond, microsecond, millisecond and second. The unit of the
> +    data is determined by the ``exponent`` field in the descriptor. The
> +    ``KVM_STATS_BASE_POW10`` flag is valid in this case. The unit of the data
> +    is determined by ``pow(10, exponent)``. For example, if value is 2000000,
> +    ``exponent`` is -6, which means the unit of statistics data is microsecond,
> +    we can get the statistics data in the unit of second by
> +    ``value * pow(10, exponent) = 2000000 * pow(10, -6) = 2 seconds``.
> +  * ``KVM_STATS_UNIT_CYCLES``
> +    It indicates that the statistics data is used to measure CPU clock cycles.
> +    The ``KVM_STATS_BASE_POW10`` flag is valid in this case. For example, if
> +    value is 200, ``exponent`` is 4, we can get the number of CPU clock cycles
> +    by ``value * pow(10, exponent) = 200 * pow(10, 4) = 2000000``.
> +
> +Bits 7-11 of ``flags`` encode the base:

Bits 8-11

> +  * ``KVM_STATS_BASE_POW10``
> +    The scale is based on power of 10. It is used for measurement of time and
> +    CPU clock cycles.
> +  * ``KVM_STATS_BASE_POW2``
> +    The scale is based on power of 2. It is used for measurement of memory size.
> +
> +The ``exponent`` field is the scale of corresponding statistics data. For
> +example, if the unit is ``KVM_STATS_UNIT_BYTES``, the base is
> +``KVM_STATS_BASE_POW2``, the ``exponent`` is 10, then we know that the real
> +unit of the statistics data is KBytes a.k.a pow(2, 10) = 1024 bytes.
> +
> +The ``size`` field is the number of values of this statistics data. It is in the
> +unit of ``unsigned long`` for VM or ``__u64`` for VCPU.
> +
> +The ``unused1`` and ``unused2`` fields are reserved for future
> +support for other types of statistics data, like log/linear histogram.
> +
> +The ``name`` field points to the name string of the statistics data. The name
> +string starts at the end of ``struct kvm_stats_desc``.
> +The maximum length (including trailing '\0') is indicated by ``name_size``
> +in ``struct kvm_stats_header``.
> +
> +The Stats Data block contains an array of data values of type ``struct
> +kvm_vm_stats_data`` or ``struct kvm_vcpu_stats_data``. It would be read by
> +user space periodically to pull statistics data.
> +The order of data value in Stats Data block is the same as the order of
> +descriptors in Descriptors block.
> +  * Statistics data for VM::
> +
> +       struct kvm_vm_stats_data {
> +               unsigned long value[0];
> +       };
> +
> +  * Statistics data for VCPU::
> +
> +       struct kvm_vcpu_stats_data {
> +               __u64 value[0];
> +       };
> +
>  5. The kvm_run structure
>  ========================
>
> @@ -6891,3 +7063,11 @@ This capability is always enabled.
>  This capability indicates that the KVM virtual PTP service is
>  supported in the host. A VMM can check whether the service is
>  available to the guest on migration.
> +
> +8.33 KVM_CAP_STATS_BINARY_FD
> +----------------------------
> +
> +:Architectures: all
> +
> +This capability indicates the feature that user space can create get a file
> +descriptor for every VM and VCPU to read statistics data in binary format.

nit: user space -> userspace (it's spelled that way throughout this document)

Cheers,
/fuad

> --
> 2.32.0.rc1.229.g3e70b5a671-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
