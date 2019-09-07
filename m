Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22830AC510
	for <lists+kvm-ppc@lfdr.de>; Sat,  7 Sep 2019 09:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390555AbfIGHFM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 7 Sep 2019 03:05:12 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38963 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388335AbfIGHFM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 7 Sep 2019 03:05:12 -0400
Received: by mail-wr1-f66.google.com with SMTP id t16so8678451wra.6;
        Sat, 07 Sep 2019 00:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uG/4ee4QFvxtO6YqUj4/6hf8mT0/4TZPno4rf5+gn9c=;
        b=FTOUBe3b1iLDFD2AKBcM8gwSBoborf46EBl+4RqfL4+qEcQADfnDxAvRimNSy67ajc
         HSa7h6Wd5HRTv2meUD6p5JyNaGopTZEAMaLB+/NMbKg4YF6s0L45Z5pE2cYIF36GcRNM
         5Sw/KbZd43ZYCoVuX0ExAqSukr41d7f20Eh6PLm7AXzTCA7h/wg+8lsj2wWWTQkNJLgF
         Zsm/nib5GR08vatVvtUOAjq+jATcrWADIPt2LCZOgVUSIGV+VYm19M4tFm+I0qK0RGMI
         jf7D1ce8NTz5gXeBVc/AsDIGc+zy7ZYV5aVfrA61qZKiFuWGzTd12gDNP423t9kz7sKr
         wb2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=uG/4ee4QFvxtO6YqUj4/6hf8mT0/4TZPno4rf5+gn9c=;
        b=qbOLch6PYmePBCLSxDdLO4EdaeSrc6CgpUm9MIBJEsMKPqrAlS/WuAPbQtYhDVfqVW
         SAM6V9tghABeoXldf24mYjaHuJOGu0rFqgR1g7iU63IdNhrpa2tClaIOK+ByCO85dXQn
         0CTtZNQIC2qm/uWwCLqUt0KTv2oPBpvAM6CYi0u2NvosrDS0d4ox5UBhCmDbNioDVmtK
         B0rToDhoVMbs3JYVZuCe7/YbSbVIJRWMS2hRSvlDUjXzTd2mqW5rE8lyTeLlDQUW4sSn
         1fIT7h0jYB2gdJDD3llEj/GpLZqfmutX71C7HByL7JwAV5oM0xnrjrPTWphVr/2+FqqI
         vI5w==
X-Gm-Message-State: APjAAAVynj/dOuw+ALzxbILhQI89SO5sgznZE8fFesjErqwfTM4kHwhj
        16KDc5MO2Ba5H1zUgS3iw/4=
X-Google-Smtp-Source: APXvYqw2AY9QlhJaEyP4D5m/vtc4Ci+Vs0emJ7CXSHVzaCW1j53cQKUHcAWB5KeOXdAr8Zbn6dkS/g==
X-Received: by 2002:a5d:438c:: with SMTP id i12mr9716673wrq.238.1567839908891;
        Sat, 07 Sep 2019 00:05:08 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id b184sm16203809wmg.47.2019.09.07.00.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 00:05:07 -0700 (PDT)
Date:   Sat, 7 Sep 2019 09:05:05 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Qian Cai <cai@lca.pw>
Cc:     mpe@ellerman.id.au, peterz@infradead.org, bvanassche@acm.org,
        arnd@arndb.de, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH v2] powerpc/lockdep: fix a false positive warning
Message-ID: <20190907070505.GA88784@gmail.com>
References: <20190906231754.830-1-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906231754.830-1-cai@lca.pw>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


* Qian Cai <cai@lca.pw> wrote:

> The commit 108c14858b9e ("locking/lockdep: Add support for dynamic
> keys") introduced a boot warning on powerpc below, because since the
> commit 2d4f567103ff ("KVM: PPC: Introduce kvm_tmp framework") adds
> kvm_tmp[] into the .bss section and then free the rest of unused spaces
> back to the page allocator.
> 
> kernel_init
>   kvm_guest_init
>     kvm_free_tmp
>       free_reserved_area
>         free_unref_page
>           free_unref_page_prepare
> 
> Later, alloc_workqueue() happens to allocate some pages from there and
> trigger the warning at,
> 
> if (WARN_ON_ONCE(static_obj(key)))
> 
> Fix it by adding a generic helper arch_is_bss_hole() to skip those areas
> in static_obj(). Since kvm_free_tmp() is only done early during the
> boot, just go lockless to make the implementation simple for now.
> 
> WARNING: CPU: 0 PID: 13 at kernel/locking/lockdep.c:1120
> Workqueue: events work_for_cpu_fn
> Call Trace:
>   lockdep_register_key+0x68/0x200
>   wq_init_lockdep+0x40/0xc0
>   trunc_msg+0x385f9/0x4c30f (unreliable)
>   wq_init_lockdep+0x40/0xc0
>   alloc_workqueue+0x1e0/0x620
>   scsi_host_alloc+0x3d8/0x490
>   ata_scsi_add_hosts+0xd0/0x220 [libata]
>   ata_host_register+0x178/0x400 [libata]
>   ata_host_activate+0x17c/0x210 [libata]
>   ahci_host_activate+0x84/0x250 [libahci]
>   ahci_init_one+0xc74/0xdc0 [ahci]
>   local_pci_probe+0x78/0x100
>   work_for_cpu_fn+0x40/0x70
>   process_one_work+0x388/0x750
>   process_scheduled_works+0x50/0x90
>   worker_thread+0x3d0/0x570
>   kthread+0x1b8/0x1e0
>   ret_from_kernel_thread+0x5c/0x7c
> 
> Fixes: 108c14858b9e ("locking/lockdep: Add support for dynamic keys")
> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
> 
> v2: No need to actually define arch_is_bss_hole() powerpc64 only.
> 
>  arch/powerpc/include/asm/sections.h | 11 +++++++++++
>  arch/powerpc/kernel/kvm.c           |  5 +++++
>  include/asm-generic/sections.h      |  7 +++++++
>  kernel/locking/lockdep.c            |  3 +++
>  4 files changed, 26 insertions(+)
> 
> diff --git a/arch/powerpc/include/asm/sections.h b/arch/powerpc/include/asm/sections.h
> index 4a1664a8658d..4f5d69c42017 100644
> --- a/arch/powerpc/include/asm/sections.h
> +++ b/arch/powerpc/include/asm/sections.h
> @@ -5,8 +5,19 @@
>  
>  #include <linux/elf.h>
>  #include <linux/uaccess.h>
> +
> +#define arch_is_bss_hole arch_is_bss_hole
> +
>  #include <asm-generic/sections.h>
>  
> +extern void *bss_hole_start, *bss_hole_end;
> +
> +static inline int arch_is_bss_hole(unsigned long addr)
> +{
> +	return addr >= (unsigned long)bss_hole_start &&
> +	       addr < (unsigned long)bss_hole_end;
> +}
> +
>  extern char __head_end[];
>  
>  #ifdef __powerpc64__
> diff --git a/arch/powerpc/kernel/kvm.c b/arch/powerpc/kernel/kvm.c
> index b7b3a5e4e224..89e0e522e125 100644
> --- a/arch/powerpc/kernel/kvm.c
> +++ b/arch/powerpc/kernel/kvm.c
> @@ -66,6 +66,7 @@
>  static bool kvm_patching_worked = true;
>  char kvm_tmp[1024 * 1024];
>  static int kvm_tmp_index;
> +void *bss_hole_start, *bss_hole_end;
>  
>  static inline void kvm_patch_ins(u32 *inst, u32 new_inst)
>  {
> @@ -707,6 +708,10 @@ static __init void kvm_free_tmp(void)
>  	 */
>  	kmemleak_free_part(&kvm_tmp[kvm_tmp_index],
>  			   ARRAY_SIZE(kvm_tmp) - kvm_tmp_index);
> +
> +	bss_hole_start = &kvm_tmp[kvm_tmp_index];
> +	bss_hole_end = &kvm_tmp[ARRAY_SIZE(kvm_tmp)];
> +
>  	free_reserved_area(&kvm_tmp[kvm_tmp_index],
>  			   &kvm_tmp[ARRAY_SIZE(kvm_tmp)], -1, NULL);
>  }
> diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
> index d1779d442aa5..4d8b1f2c5fd9 100644
> --- a/include/asm-generic/sections.h
> +++ b/include/asm-generic/sections.h
> @@ -91,6 +91,13 @@ static inline int arch_is_kernel_initmem_freed(unsigned long addr)
>  }
>  #endif
>  
> +#ifndef arch_is_bss_hole
> +static inline int arch_is_bss_hole(unsigned long addr)
> +{
> +	return 0;
> +}
> +#endif
> +
>  /**
>   * memory_contains - checks if an object is contained within a memory region
>   * @begin: virtual address of the beginning of the memory region
> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> index 4861cf8e274b..cd75b51f15ce 100644
> --- a/kernel/locking/lockdep.c
> +++ b/kernel/locking/lockdep.c
> @@ -675,6 +675,9 @@ static int static_obj(const void *obj)
>  	if (arch_is_kernel_initmem_freed(addr))
>  		return 0;
>  
> +	if (arch_is_bss_hole(addr))
> +		return 0;

arch_is_bss_hole() should use a 'bool' - but other than that, this 
looks good to me, if the PowerPC maintainers agree too.

Thanks,

	Ingo
