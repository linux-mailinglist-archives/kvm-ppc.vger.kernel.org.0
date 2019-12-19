Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68361126036
	for <lists+kvm-ppc@lfdr.de>; Thu, 19 Dec 2019 12:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfLSLAC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 19 Dec 2019 06:00:02 -0500
Received: from ozlabs.org ([203.11.71.1]:52745 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbfLSLAC (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 19 Dec 2019 06:00:02 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47dpmv6hY7z9sP6;
        Thu, 19 Dec 2019 21:59:59 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1576753200;
        bh=9DgfDxZL5lACm7q7lGR4p4NUM1XFDLiTxKkghwiemps=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=nz2yMamR5Xe2QWdPYkhMRyh1CLRDqCncJ11UYMCTNVa6Z1vwdydd0jwDzncIfjdNM
         uvcKQFa2ebttLB5XOxJBvwJvT3YgyPrftUyHKq0BkRd1Iiz8ptA+EhdwnNcrirA8ER
         pFM3s9AowbxXPc2MrfHr4Li/S0aaFCHO4tURaczvt8YNzfDeC5J89U7tovNhmau9Vj
         7h/NdRE+O+7jvSTGY8RHQbthsZw+kURqLXwCrXfdEl1A4UCrUoFGrjkDsbo+LWvBwT
         5k9tWXTMbDyGc3co/jU/rcLFdhoEMXqIVFnRkvx2QRsXtXi8Pp1X3QzUEqhSgJJVbL
         ++utJbTOL+kYQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>, linuxram@us.ibm.com,
        bauerman@linux.ibm.com, andmike@linux.ibm.com,
        linuxppc-dev@ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 1/2] powerpc/pseries/svm: Don't access some SPRs
In-Reply-To: <20191218235753.GA12285@us.ibm.com>
References: <20191218043048.3400-1-sukadev@linux.ibm.com> <875zidoqok.fsf@mpe.ellerman.id.au> <20191218235753.GA12285@us.ibm.com>
Date:   Thu, 19 Dec 2019 21:59:57 +1100
Message-ID: <87immcmvgy.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:
> Michael Ellerman [mpe@ellerman.id.au] wrote:
>> 
>> eg. here.
>> 
>> This is the fast path of context switch.
>> 
>> That expands to:
>> 
>> 	if (!(mfmsr() & MSR_S))
>> 		asm volatile("mfspr %0, SPRN_BESCR" : "=r" (rval));
>> 	if (!(mfmsr() & MSR_S))
>> 		asm volatile("mfspr %0, SPRN_EBBHR" : "=r" (rval));
>> 	if (!(mfmsr() & MSR_S))
>> 		asm volatile("mfspr %0, SPRN_EBBRR" : "=r" (rval));
>> 
>
> Yes, should have optimized this at least :-)
>> 
>> If the Ultravisor is going to disable EBB and BHRB then we need new
>> CPU_FTR bits for those, and the code that accesses those registers
>> needs to be put behind cpu_has_feature(EBB) etc.
>
> Will try the cpu_has_feature(). Would it be ok to use a single feature
> bit, like UV or make it per-register group as that could need more
> feature bits?

We already have a number of places using is_secure_guest():

  arch/powerpc/include/asm/mem_encrypt.h: return is_secure_guest();
  arch/powerpc/include/asm/mem_encrypt.h: return is_secure_guest();
  arch/powerpc/include/asm/svm.h:#define get_dtl_cache_ctor()     (is_secure_guest() ? dtl_cache_ctor : NULL)
  arch/powerpc/kernel/machine_kexec_64.c: if (is_secure_guest() && !(image->preserve_context ||
  arch/powerpc/kernel/paca.c:     if (is_secure_guest())
  arch/powerpc/kernel/sysfs.c:    return sprintf(buf, "%u\n", is_secure_guest());
  arch/powerpc/platforms/pseries/iommu.c: if (!is_secure_guest())
  arch/powerpc/platforms/pseries/smp.c:   if (cpu_has_feature(CPU_FTR_DBELL) && !is_secure_guest())
  arch/powerpc/platforms/pseries/svm.c:   if (!is_secure_guest())


Which could all (or mostly) be converted to use a cpu_has_feature(CPU_FTR_SVM).

So yeah I guess it makes sense to do that, create a CPU_FTR_SVM and set
it early in boot based on MSR_S.

You could argue it's a firmware feature, so should be FW_FEATURE_SVM,
but we don't use jump_labels for firmware features so they're not as
nice for hot-path code like register switching. Also the distinction
between CPU and firmware features is a bit arbitrary.

cheers
