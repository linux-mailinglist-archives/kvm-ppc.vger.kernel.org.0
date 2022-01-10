Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9558B488EE5
	for <lists+kvm-ppc@lfdr.de>; Mon, 10 Jan 2022 04:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238339AbiAJDVF (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 9 Jan 2022 22:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbiAJDVF (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 9 Jan 2022 22:21:05 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9F6C06173F
        for <kvm-ppc@vger.kernel.org>; Sun,  9 Jan 2022 19:21:04 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id q14so10775795plx.4
        for <kvm-ppc@vger.kernel.org>; Sun, 09 Jan 2022 19:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qIzdLZrwJhMt1nWE11pWljtXDkVev1UMLH6KZdKL0mc=;
        b=GXBF+LW6+nuKGzsbZWnyF4QOoYsv1mUypepag0dkAOn7tax/E5NgCcnyL0OIt5KL5I
         Bbvm0nBc3I0vQON/OwqbYAxY0Kv0GdaNGktrg379VCmlvGLOCqrNNDA90hDas7hyH7/p
         iedLBq0BG26+8UH/fphJTtJaTGL3VIScFoOcIa9cecvWCRJXRN+JofG6mFkIkaO1NtmM
         9WuKM1TamKLOo8JdYP232PCf8zmeisZi8du4P4+0KeslD1JBQPKHf2Xw9xKp1tSDCWyR
         IIHNnfhdU2c3nOvxGDfIas2ZBRQL1l2qykjstzqCn9h30bMJDlrUpv73wdMvju4AeKz4
         8gDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qIzdLZrwJhMt1nWE11pWljtXDkVev1UMLH6KZdKL0mc=;
        b=XErhRTUOnxFQlpbI5dARH2lLqjhGK68s606RFu/++Lyj9llLwqq8w72PUA9ptu7mhL
         m4px8HDXSrtsUPI2egtAq0iRSt9zcI1xyFXNtveLwhAjRuKL1kn8Kra8A+CSV5EvDi9v
         fafkDcMyZSmJ0EkfE6jTf6IzcyWE0TMANPhHo1QfYspGsH991uZRjK6lHIp0+mYobgb0
         vzh+Bj//5ikCslQyre4xJ7tj1nJ0mynobXASA02WEgvJ6PR2kfSyVcRUIo+9ahVbXNTN
         nBOQDbPnZluMuSQCo4nrAQmvteKJVlbRb+kQmuahCLA9F4KffGcWvthh4FgGbpFMhBJa
         xALA==
X-Gm-Message-State: AOAM531C9M6xq43cUBQJxZIBrJunIIZHuVb3Ed0utNbV5fnncRayrLqX
        X1bmfzLfXbHAoIkCaR1U/k1EhO3TO9CKnW5O
X-Google-Smtp-Source: ABdhPJyMJ7nGOq9baGtL0KdQ8RqTjf5qKgEMXjusMZJZT1KPNJSquC3EqQFtwZfmjaUUKv3wN2B90A==
X-Received: by 2002:a17:90a:191a:: with SMTP id 26mr2086001pjg.50.1641784864100;
        Sun, 09 Jan 2022 19:21:04 -0800 (PST)
Received: from [192.168.10.153] (203-7-124-83.dyn.iinet.net.au. [203.7.124.83])
        by smtp.gmail.com with ESMTPSA id h5sm4942613pfi.46.2022.01.09.19.21.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Jan 2022 19:21:03 -0800 (PST)
Message-ID: <2d299fdf-1876-61a2-5569-38aab9747ff4@ozlabs.ru>
Date:   Mon, 10 Jan 2022 14:20:58 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH v3 4/6] KVM: PPC: mmio: Queue interrupt at
 kvmppc_emulate_mmio
Content-Language: en-US
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com
References: <20220107210012.4091153-1-farosas@linux.ibm.com>
 <20220107210012.4091153-5-farosas@linux.ibm.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20220107210012.4091153-5-farosas@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 08/01/2022 08:00, Fabiano Rosas wrote:
> If MMIO emulation fails, we queue a Program interrupt to the
> guest. Move that line up into kvmppc_emulate_mmio, which is where we
> set RESUME_GUEST/HOST. This allows the removal of the 'advance'
> variable.
> 
> No functional change, just separation of responsibilities.
> 
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>


Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>


> ---
>   arch/powerpc/kvm/emulate_loadstore.c | 8 +-------
>   arch/powerpc/kvm/powerpc.c           | 2 +-
>   2 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/emulate_loadstore.c b/arch/powerpc/kvm/emulate_loadstore.c
> index 48272a9b9c30..4dec920fe4c9 100644
> --- a/arch/powerpc/kvm/emulate_loadstore.c
> +++ b/arch/powerpc/kvm/emulate_loadstore.c
> @@ -73,7 +73,6 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
>   {
>   	u32 inst;
>   	enum emulation_result emulated = EMULATE_FAIL;
> -	int advance = 1;
>   	struct instruction_op op;
>   
>   	/* this default type might be overwritten by subcategories */
> @@ -355,15 +354,10 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
>   		}
>   	}
>   
> -	if (emulated == EMULATE_FAIL) {
> -		advance = 0;
> -		kvmppc_core_queue_program(vcpu, 0);
> -	}
> -
>   	trace_kvm_ppc_instr(inst, kvmppc_get_pc(vcpu), emulated);
>   
>   	/* Advance past emulated instruction. */
> -	if (advance)
> +	if (emulated != EMULATE_FAIL)
>   		kvmppc_set_pc(vcpu, kvmppc_get_pc(vcpu) + 4);
>   
>   	return emulated;
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 4d7d0d080232..6daeea4a7de1 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -307,7 +307,7 @@ int kvmppc_emulate_mmio(struct kvm_vcpu *vcpu)
>   		u32 last_inst;
>   
>   		kvmppc_get_last_inst(vcpu, INST_GENERIC, &last_inst);
> -		/* XXX Deliver Program interrupt to guest. */
> +		kvmppc_core_queue_program(vcpu, 0);
>   		pr_info("%s: emulation failed (%08x)\n", __func__, last_inst);
>   		r = RESUME_HOST;
>   		break;
