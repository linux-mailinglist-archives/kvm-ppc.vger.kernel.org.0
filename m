Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1791D3340EA
	for <lists+kvm-ppc@lfdr.de>; Wed, 10 Mar 2021 15:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbhCJO6i (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 10 Mar 2021 09:58:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:44930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhCJO6e (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 10 Mar 2021 09:58:34 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20FF764EFD;
        Wed, 10 Mar 2021 14:58:34 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.misterjones.org)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lK0IC-000mlJ-5Q; Wed, 10 Mar 2021 14:58:32 +0000
Date:   Wed, 10 Mar 2021 14:58:30 +0000
Message-ID: <877dmfxdgp.wl-maz@kernel.org>
From:   Marc Zyngier <maz@kernel.org>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVM ARM <kvmarm@lists.cs.columbia.edu>,
        Linux MIPS <linux-mips@vger.kernel.org>,
        KVM PPC <kvm-ppc@vger.kernel.org>,
        Linux S390 <linux-s390@vger.kernel.org>,
        Linux kselftest <linux-kselftest@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: Re: [RFC PATCH 2/4] KVM: stats: Define APIs for aggregated stats retrieval in binary format
In-Reply-To: <20210310003024.2026253-3-jingzhangos@google.com>
References: <20210310003024.2026253-1-jingzhangos@google.com>
        <20210310003024.2026253-3-jingzhangos@google.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/27.1
 (x86_64-pc-linux-gnu) MULE/6.0 (HANACHIRUSATO)
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: jingzhangos@google.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org, linux-s390@vger.kernel.org, linux-kselftest@vger.kernel.org, pbonzini@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, tsbogend@alpha.franken.de, paulus@ozlabs.org, borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com, seanjc@google.com, vkuznets@redhat.com, jmattson@google.com, pshier@google.com, oupton@google.com, rientjes@google.com, eesposit@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 10 Mar 2021 00:30:22 +0000,
Jing Zhang <jingzhangos@google.com> wrote:
> 
> Define ioctl commands for VM/vCPU aggregated statistics data retrieval
> in binary format and update corresponding API documentation.
> 
> The capability and ioctl are not enabled for now.
> No functional change intended.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 79 ++++++++++++++++++++++++++++++++++
>  include/linux/kvm_host.h       |  1 -
>  include/uapi/linux/kvm.h       | 60 ++++++++++++++++++++++++++
>  3 files changed, 139 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 1a2b5210cdbf..aa4b5270c966 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4938,6 +4938,76 @@ see KVM_XEN_VCPU_SET_ATTR above.
>  The KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST type may not be used
>  with the KVM_XEN_VCPU_GET_ATTR ioctl.
>  
> +4.131 KVM_STATS_GET_INFO
> +------------------------
> +
> +:Capability: KVM_CAP_STATS_BINARY_FORM
> +:Architectures: all
> +:Type: vm ioctl, vcpu ioctl
> +:Parameters: struct kvm_stats_info (out)
> +:Returns: 0 on success, < 0 on error


Missing description of the errors (this is throughout the document).

> +
> +::
> +
> +  struct kvm_stats_info {
> +        __u32 num_stats;
> +  };
> +
> +This ioctl is used to get the information about VM or vCPU statistics data.
> +The number of statistics data would be returned in field num_stats in
> +struct kvm_stats_info. This ioctl only needs to be called once on running
> +VMs on the same architecture.

Is this allowed to be variable across VMs? Or is that a constant for a
given host system boot?

Given that this returns a single field, is there any value in copying
this structure across? Could it be returned by the ioctl itself
instead, at the expense of only being a 31bit value?

> +
> +4.132 KVM_STATS_GET_NAMES
> +-------------------------
> +
> +:Capability: KVM_CAP_STATS_BINARY_FORM
> +:Architectures: all
> +:Type: vm ioctl, vcpu ioctl
> +:Parameters: struct kvm_stats_names (in/out)
> +:Returns: 0 on success, < 0 on error
> +
> +::
> +
> +  #define KVM_STATS_NAME_LEN		32
> +  struct kvm_stats_names {
> +	__u32 size;
> +	__u8  names[0];
> +  };
> +
> +This ioctl is used to get the string names of all the statistics data for VM
> +or vCPU. Users must use KVM_STATS_GET_INFO to find the number of statistics.
> +They must allocate a buffer of the size num_stats * KVM_STATS_NAME_LEN
> +immediately following struct kvm_stats_names. The size field of kvm_stats_name
> +must contain the buffer size as an input.

What is the unit for the buffer size? bytes? or number of "names"?

> +The buffer can be treated like a string array, each name string is null-padded
> +to a size of KVM_STATS_NAME_LEN;

Is this allowed to query fewer strings than described by
kvm_stats_info? If it isn't, I question the need for the "size"
field. Either there is enough space in the buffer passed by userspace,
or -EFAULT is returned.

> +This ioclt only needs to be called once on running VMs on the same architecture.

Same question about the immutability of these names.

> +
> +4.133 KVM_STATS_GET_DATA
> +-------------------------
> +
> +:Capability: KVM_CAP_STATS_BINARY_FORM
> +:Architectures: all
> +:Type: vm ioctl, vcpu ioctl
> +:Parameters: struct kvm_stats_data (in/out)
> +:Returns: 0 on success, < 0 on error
> +
> +::
> +
> +  struct kvm_stats_data {
> +	__u32 size;

Same question about the actual need for this field.

> +	__u64 data[0];

So userspace always sees a 64bit quantify per stat. My earlier comment
about the ulong/u64 discrepancy stands! ;-)

> +  };
> +
> +This ioctl is used to get the aggregated statistics data for VM or vCPU.
> +Users must use KVM_STATS_GET_INFO to find the number of statistics.
> +They must allocate a buffer of the appropriate size num_stats * sizeof(data[0])
> +immediately following struct kvm_stats_data. The size field of kvm_stats_data
> +must contain the buffer size as an input.
> +The data buffer 1-1 maps to name strings buffer in sequential order.
> +This ioctl is usually called periodically to pull statistics data.

Is there any provision to reset the counters on read?

> +
>  5. The kvm_run structure
>  ========================
>  
> @@ -6721,3 +6791,12 @@ vcpu_info is set.
>  The KVM_XEN_HVM_CONFIG_RUNSTATE flag indicates that the runstate-related
>  features KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR/_CURRENT/_DATA/_ADJUST are
>  supported by the KVM_XEN_VCPU_SET_ATTR/KVM_XEN_VCPU_GET_ATTR ioctls.
> +
> +8.31 KVM_CAP_STATS_BINARY_FORM
> +------------------------------
> +
> +:Architectures: all
> +
> +This capability indicates that KVM supports retrieving aggregated statistics
> +data in binary format with corresponding VM/VCPU ioctl KVM_STATS_GET_INFO,
> +KVM_STATS_GET_NAMES and KVM_STATS_GET_DATA.

nit: for ease of reviewing, consider splitting the documentation in a
separate patch.

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 1ea297458306..f2dabf457717 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1164,7 +1164,6 @@ static inline bool kvm_is_error_gpa(struct kvm *kvm, gpa_t gpa)
>  
>  #define VM_STAT_COUNT		(sizeof(struct kvm_vm_stat)/sizeof(ulong))
>  #define VCPU_STAT_COUNT		(sizeof(struct kvm_vcpu_stat)/sizeof(u64))
> -#define KVM_STATS_NAME_LEN	32
>  
>  /* Make sure it is synced with fields in struct kvm_vm_stat. */
>  extern const char kvm_vm_stat_strings[][KVM_STATS_NAME_LEN];
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index f6afee209620..ad185d4c5e42 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1078,6 +1078,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_DIRTY_LOG_RING 192
>  #define KVM_CAP_X86_BUS_LOCK_EXIT 193
>  #define KVM_CAP_PPC_DAWR1 194
> +#define KVM_CAP_STATS_BINARY_FORM 195
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -1853,4 +1854,63 @@ struct kvm_dirty_gfn {
>  #define KVM_BUS_LOCK_DETECTION_OFF             (1 << 0)
>  #define KVM_BUS_LOCK_DETECTION_EXIT            (1 << 1)
>  
> +/* Available with KVM_CAP_STATS_BINARY_FORM */
> +
> +#define KVM_STATS_NAME_LEN		32
> +
> +/**
> + * struct kvm_stats_info - statistics information
> + *
> + * Used as parameter for ioctl %KVM_STATS_GET_INFO.
> + *
> + * @num_stats: On return, the number of statistics data of vm or vcpu.
> + *
> + */
> +struct kvm_stats_info {
> +	__u32 num_stats;
> +};
> +
> +/**
> + * struct kvm_stats_names - string list of statistics names
> + *
> + * Used as parameter for ioctl %KVM_STATS_GET_NAMES.
> + *
> + * @size: Input from user, indicating the size of buffer after the struture.
> + * @names: Buffer of name string list for vm or vcpu. Each string is
> + *	null-padded to a size of %KVM_STATS_NAME_LEN.
> + *
> + * Users must use %KVM_STATS_GET_INFO to find the number of
> + * statistics. They must allocate a buffer of the appropriate
> + * size (>= &struct kvm_stats_info @num_stats * %KVM_STATS_NAME_LEN)
> + * immediately following this struture.
> + */
> +struct kvm_stats_names {
> +	__u32 size;
> +	__u8  names[0];
> +};
> +
> +/**
> + * struct kvm_stats_data - statistics data array
> + *
> + * Used as parameter for ioctl %KVM_STATS_GET_DATA.
> + *
> + * @size: Input from user, indicating the size of buffer after the struture.
> + * @data: Buffer of statistics data for vm or vcpu.
> + *
> + * Users must use %KVM_STATS_GET_INFO to find the number of
> + * statistics. They must allocate a buffer of the appropriate
> + * size (>= &struct kvm_stats_info @num_stats * sizeof(@data[0])
> + * immediately following this structure.
> + * &struct kvm_stats_names @names 1-1 maps to &structkvm_stats_data
> + * @data in sequential order.
> + */
> +struct kvm_stats_data {
> +	__u32 size;
> +	__u64 data[0];
> +};
> +
> +#define KVM_STATS_GET_INFO		_IOR(KVMIO, 0xcc, struct kvm_stats_info)
> +#define KVM_STATS_GET_NAMES		_IOR(KVMIO, 0xcd, struct kvm_stats_names)
> +#define KVM_STATS_GET_DATA		_IOR(KVMIO, 0xce, struct kvm_stats_data)
> +
>  #endif /* __LINUX_KVM_H */
> -- 
> 2.30.1.766.gb4fecdf3b7-goog
> 
> 

Thanks,

	M.

-- 
Without deviation from the norm, progress is not possible.
