Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDB66CB988
	for <lists+kvm-ppc@lfdr.de>; Fri,  4 Oct 2019 13:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbfJDLyi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 4 Oct 2019 07:54:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59060 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbfJDLyi (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 4 Oct 2019 07:54:38 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 066C8CFD4
        for <kvm-ppc@vger.kernel.org>; Fri,  4 Oct 2019 11:54:37 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id b6so2637292wrx.0
        for <kvm-ppc@vger.kernel.org>; Fri, 04 Oct 2019 04:54:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MaDAtO5FuA07xsP/8gm3NAVFqF1Q5uvohKJcAR0Oaqc=;
        b=Rt0wGtdbhtdi8q/N2+NZqZ4Hm1wEVM1dk/dvvQVEaf90GP4V8Sft0AY/g8P3vNDDXL
         ZsFviZuOhKrshTiPCHnKX/DVA33fsIswqAbvSZAvHKi1qAK+bn6FvN9CLK/BkE/eWp+O
         n8jA7NRN6Gq27H0D1sidUVCPr26JUocdygQFMiC01rUMOk7mTo6X3y70zseDI73JOEuU
         4hbot8zC2MvMTZCewXOHy1/NQdhT+g5uWHbTEmn1b4MjIl3QyocqN8/t1WVkQIRN68z4
         d4An+z3nuObzH4k134nBQ0rU9tP9huJOZGdbdoml7oyZ2fdFt0W7tgLRjVBvNrDYk6Oj
         2QDA==
X-Gm-Message-State: APjAAAUxKyV0c/Dc3dH9X7tpyYI2t7ljcTLjxXVxdhhMeBfj42cA5fEr
        PkO/wQQIVfgNaahFTNPyOq9KL982ZjPfoRmDB6HzSzRq/UJoNcDv+jeNvYzTVutdmSOgc4qkhVI
        BYi9+4RvPCFKTLkTepw==
X-Received: by 2002:adf:f691:: with SMTP id v17mr5922063wrp.81.1570190075669;
        Fri, 04 Oct 2019 04:54:35 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwScKk603Pv+4O2QKax6w49Vr0Ji2Dd2f8VfsHyG9FPcoBcpXOVW6Yl0sGLbftH/qBiHn2oMQ==
X-Received: by 2002:adf:f691:: with SMTP id v17mr5922045wrp.81.1570190075332;
        Fri, 04 Oct 2019 04:54:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e56d:fbdf:8b79:c79c? ([2001:b07:6468:f312:e56d:fbdf:8b79:c79c])
        by smtp.gmail.com with ESMTPSA id q10sm14380218wrd.39.2019.10.04.04.54.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2019 04:54:34 -0700 (PDT)
Subject: Re: [PATCH] powerpc: Fix up RTAS invocation for new qemu versions
To:     David Gibson <david@gibson.dropbear.id.au>, lvivier@redhat.com,
        thuth@redhat.com
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, rkrcmar@redhat.com
References: <20191004103844.32590-1-david@gibson.dropbear.id.au>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a384c5e2-472a-32e5-2ee1-65c40da29840@redhat.com>
Date:   Fri, 4 Oct 2019 13:54:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191004103844.32590-1-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 04/10/19 12:38, David Gibson wrote:
> In order to call RTAS functions on powerpc kvm-unit-tests relies on the
> RTAS blob supplied by qemu.  But new versions of qemu don't supply an RTAS
> blob: since the normal way for guests to get RTAS is to call the guest
> firmware's instantiate-rtas function, we now rely on that guest firmware
> to provide the RTAS code itself.
> 
> But qemu-kvm-tests bypasses the usual guest firmware to just run itself,
> so we can't get the rtas blob from SLOF.
> 
> But.. in fact the RTAS blob under qemu is a bit of a sham anyway - it's
> a tiny wrapper that forwards the RTAS call to a hypercall.  So, we can
> just invoke that hypercall directly.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>

Would it be hard to call instantiate-rtas?  I'm not sure if you have any
interest in running kvm-unit-tests on hypervisors that might have a
different way to process RTAS calls.

Paolo

> ---
>  lib/powerpc/asm/hcall.h |  3 +++
>  lib/powerpc/rtas.c      |  6 +++---
>  powerpc/cstart64.S      | 20 ++++++++++++++++----
>  3 files changed, 22 insertions(+), 7 deletions(-)
> 
> So.. "new versions of qemu" in this case means ones that incorporate
> the pull request I just sent today.
> 
> diff --git a/lib/powerpc/asm/hcall.h b/lib/powerpc/asm/hcall.h
> index a8bd7e3..1173fea 100644
> --- a/lib/powerpc/asm/hcall.h
> +++ b/lib/powerpc/asm/hcall.h
> @@ -24,6 +24,9 @@
>  #define H_RANDOM		0x300
>  #define H_SET_MODE		0x31C
>  
> +#define KVMPPC_HCALL_BASE	0xf000
> +#define KVMPPC_H_RTAS		(KVMPPC_HCALL_BASE + 0x0)
> +
>  #ifndef __ASSEMBLY__
>  /*
>   * hcall_have_broken_sc1 checks if we're on a host with a broken sc1.
> diff --git a/lib/powerpc/rtas.c b/lib/powerpc/rtas.c
> index 2e7e0da..41c0a24 100644
> --- a/lib/powerpc/rtas.c
> +++ b/lib/powerpc/rtas.c
> @@ -46,9 +46,9 @@ void rtas_init(void)
>  	prop = fdt_get_property(dt_fdt(), node,
>  				"linux,rtas-entry", &len);
>  	if (!prop) {
> -		printf("%s: /rtas/linux,rtas-entry: %s\n",
> -				__func__, fdt_strerror(len));
> -		abort();
> +		/* We don't have a qemu provided RTAS blob, enter_rtas
> +		 * will use H_RTAS directly */
> +		return;
>  	}
>  	data = (u32 *)prop->data;
>  	rtas_entry = (unsigned long)fdt32_to_cpu(*data);
> diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
> index ec673b3..972851f 100644
> --- a/powerpc/cstart64.S
> +++ b/powerpc/cstart64.S
> @@ -121,13 +121,25 @@ halt:
>  
>  .globl enter_rtas
>  enter_rtas:
> +	LOAD_REG_ADDR(r11, rtas_entry)
> +	ld	r10, 0(r11)
> +
> +	cmpdi	r10,0
> +	bne	external_rtas
> +
> +	/* Use H_RTAS directly */
> +	mr	r4,r3
> +	lis	r3,KVMPPC_H_RTAS@h
> +	ori	r3,r3,KVMPPC_H_RTAS@l
> +	b	hcall
> +
> +external_rtas:
> +	/* Use external RTAS blob */
>  	mflr	r0
>  	std	r0, 16(r1)
>  
> -	LOAD_REG_ADDR(r10, rtas_return_loc)
> -	mtlr	r10
> -	LOAD_REG_ADDR(r11, rtas_entry)
> -	ld	r10, 0(r11)
> +	LOAD_REG_ADDR(r11, rtas_return_loc)
> +	mtlr	r11
>  
>  	mfmsr	r11
>  	LOAD_REG_IMMEDIATE(r9, RTAS_MSR_MASK)
> 

