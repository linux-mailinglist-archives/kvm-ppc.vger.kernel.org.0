Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE88E37FF81
	for <lists+kvm-ppc@lfdr.de>; Thu, 13 May 2021 22:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbhEMU4W (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 13 May 2021 16:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbhEMU4V (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 13 May 2021 16:56:21 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D3DC06175F
        for <kvm-ppc@vger.kernel.org>; Thu, 13 May 2021 13:55:11 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id h4so40368093lfv.0
        for <kvm-ppc@vger.kernel.org>; Thu, 13 May 2021 13:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=M44SO0uoSJzYJ9SKzXZE5cFr5EetjPFOZBrp4CQPL5w=;
        b=PhSHGSOBlih6yPBEhHUaleoS71804WhKJeBbmw/azmuVp7qr5wIHjWJQdDNoTYP6ES
         jVMwzSz0lIVr6qH+VTlu0rCsoO/lSEzLEc7prCOBAZBLvPYE+b5eIvPs6axElwH7wwdz
         KznZq5JE5fQCqCwkWToJWj67kJz9k/pprOznw2UpmZ0VTB1RWGmmjJyDc7MLzhuKZo3b
         n6GhpFNoVpDyMESqR/DU4AV/FTzfGsLNkq22i2T7Kd3EAGVQcNnyabhFQfNrR+qfGBLI
         XHUkSWzpwbmIqOXiWzMQWGSbv8S4rLmVMPnnZWpFWaJpjM1WjWQZI+xjkYchuDrmterL
         KngQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=M44SO0uoSJzYJ9SKzXZE5cFr5EetjPFOZBrp4CQPL5w=;
        b=uVHMNwIMNz7LPcElBTZuZ2klElZyjF5bwOP4IZqV9pYmi3HKJl7ekHK6r3J1SxwiEG
         O/rfbLrJIM639dYeshaelHnnTnHDl07geGl/VTeZ6Ztrcum5faJ/OVGfhPHXD0jf7/Yt
         OCtsmQZCk8FlqyiiVdvNskSOvCjMZ/5A7ZrBl0nXv01aPmN3TPOfDYdj1SV5mjfNukDs
         N3+pLjwCECyOHfEBRHSy6q40l85y38EuRUrRyHq51L9OjkRFlzOaS/TuwDQJjO540CmI
         mzPQx75vuh4c+OxI6Z79QQXrTQxsF//ZSgWzT1c4nBwaqjGGedv9wweN/OxG/WVZx7AB
         Aazg==
X-Gm-Message-State: AOAM530mJW39HC59fZxwqcZVqDXaxplMfkADl6TrIZABpu1cP4pt4Rpg
        vKD+BEJRtw2mbY5qN3coy9sgk1L3bkiBCtRRA71yxw==
X-Google-Smtp-Source: ABdhPJyX5A/VpufagSakFYoUDLT0y4b4CvhLDrQ3z6CCbpAwFCgSpn5i0qXkWkmj3c4f4asiDH02UQ1NeFZxRX3mF+w=
X-Received: by 2002:a05:6512:1116:: with SMTP id l22mr30043183lfg.473.1620939309295;
 Thu, 13 May 2021 13:55:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210423181727.596466-1-jingzhangos@google.com> <20210423181727.596466-4-jingzhangos@google.com>
In-Reply-To: <20210423181727.596466-4-jingzhangos@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Thu, 13 May 2021 15:54:57 -0500
Message-ID: <CAAdAUth3LyNH2OJG7sKyWieB80WPUXsMe=uskxYG_jPyxM8GrA@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] KVM: stats: Add documentation for statistics data
 binary interface
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
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
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Apr 23, 2021 at 1:17 PM Jing Zhang <jingzhangos@google.com> wrote:
>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 171 +++++++++++++++++++++++++++++++++
>  1 file changed, 171 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 8d614a577e43..faceadc2bd66 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5021,6 +5021,169 @@ see KVM_XEN_VCPU_SET_ATTR above.
>  The KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST type may not be used
>  with the KVM_XEN_VCPU_GET_ATTR ioctl.
>
> +4.130 KVM_STATS_GETFD
> +---------------------
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
> +read one time after a system boot.
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
> +KVM statistics, it is in the form of "kvm-{kvm pid}", like "kvm-12345". For
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
> +The Descriptors block is only needed to be read once after a system boot. It is
> +an array of ``struct kvm_stats_desc`` as below::
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
> +       #define KVM_STATS_SCALE_SHIFT           8
> +       #define KVM_STATS_SCALE_MASK            (0xF << KVM_STATS_SCALE_SHIFT)
> +       #define KVM_STATS_SCALE_POW10           (0x0 << KVM_STATS_SCALE_SHIFT)
> +       #define KVM_STATS_SCALE_POW2            (0x1 << KVM_STATS_SCALE_SHIFT)
> +       #define KVM_STATS_SCALE_MAX             KVM_STATS_SCALE_POW2
> +

> +       struct kvm_stats_desc {
> +               __u32 flags;
> +               __s16 exponent;
> +               __u16 size;
> +               __u32 unused1;
> +               __u32 unused2;
> +               __u8 name[0];
Should be "char name[0]" as defined in include/uapi/linux/kvm.h.
> +       };
> +
> +The ``flags`` field contains the type and unit of the statistics data described
> +by this descriptor. The following flags are supported:
> +  * ``KVM_STATS_TYPE_CUMULATIVE``
> +    The statistics data is cumulative. The value of data can only be increased.
> +    Most of the counters used in KVM are of this type.
> +    The corresponding ``count`` filed for this type is always 1.
> +  * ``KVM_STATS_TYPE_INSTANT``
> +    The statistics data is instantaneous. Its value can be increased or
> +    decreased. This type is usually used as a measurement of some resources,
> +    like the number of dirty pages, the number of large pages, etc.
> +    The corresponding ``count`` field for this type is always 1.
> +  * ``KVM_STATS_UNIT_NONE``
> +    There is no unit for the value of statistics data. This usually means that
> +    the value is a simple counter of an event.
> +  * ``KVM_STATS_UNIT_BYTES``
> +    It indicates that the statistics data is used to measure memory size, in the
> +    unit of Byte, KiByte, MiByte, GiByte, etc. The unit of the data is
> +    determined by the ``exponent`` field in the descriptor. The
> +    ``KVM_STATS_SCALE_POW2`` flag is valid in this case. The unit of the data is
> +    determined by ``pow(2, exponent)``. For example, if value is 10,
> +    ``exponent`` is 20, which means the unit of statistics data is MiByte, we
> +    can get the statistics data in the unit of Byte by
> +    ``value * pow(2, exponent) = 10 * pow(2, 20) = 10 MiByte`` which is
> +    10 * 1024 * 1024 Bytes.
> +  * ``KVM_STATS_UNIT_SECONDS``
> +    It indicates that the statistics data is used to measure time/latency, in
> +    the unit of nanosecond, microsecond, millisecond and second. The unit of the
> +    data is determined by the ``exponent`` field in the descriptor. The
> +    ``KVM_STATS_SCALE_POW10`` flag is valid in this case. The unit of the data
> +    is determined by ``pow(10, exponent)``. For example, if value is 2000000,
> +    ``exponent`` is -6, which means the unit of statistics data is microsecond,
> +    we can get the statistics data in the unit of second by
> +    ``value * pow(10, exponent) = 2000000 * pow(10, -6) = 2 seconds``.
> +  * ``KVM_STATS_UNIT_CYCLES``
> +    It indicates that the statistics data is used to measure CPU clock cycles.
> +    The ``KVM_STATS_SCALE_POW10`` flag is valid in this case. For example, if
> +    value is 200, ``exponent`` is 4, we can get the number of CPU clock cycles
> +    by ``value * pow(10, exponent) = 200 * pow(10, 4) = 2000000``.
> +
> +The ``exponent`` field is the scale of corresponding statistics data. It has two
> +values as follows:
> +  * ``KVM_STATS_SCALE_POW10``
> +    The scale is based on power of 10. It is used for measurement of time and
> +    CPU clock cycles.
> +  * ``KVM_STATS_SCALE_POW2``
> +    The scale is based on power of 2. It is used for measurement of memory size.
> +
> +The ``size`` field is the number of values of this statistics data. It is in the
> +unit of ``unsigned long`` for VCPU or ``__u64`` for VM.
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
> @@ -6888,3 +7051,11 @@ depends on the individual hypercall.
>  Right now, the only bit that can be set is bit 12, corresponding to
>  KVM_HC_PAGE_ENC_STATUS.  The hypercall returns ENOSYS if bit 12 is not
>  set or KVM_CAP_EXIT_HYPERCALL is not enabled.
> +
> +8.33 KVM_CAP_STATS_BINARY_FD
> +----------------------------
> +
> +:Architectures: all
> +
> +This capability indicates the feature that user space can create get a file
> +descriptor for every VM and VCPU to read statistics data in binary format.
> --
> 2.31.1.498.g6c1eba8ee3d-goog
>
