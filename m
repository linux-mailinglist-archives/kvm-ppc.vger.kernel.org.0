Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C78E486EB9
	for <lists+kvm-ppc@lfdr.de>; Fri,  7 Jan 2022 01:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344141AbiAGAYn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Jan 2022 19:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344117AbiAGAYg (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Jan 2022 19:24:36 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1005CC061245
        for <kvm-ppc@vger.kernel.org>; Thu,  6 Jan 2022 16:24:36 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 8so3988639pgc.10
        for <kvm-ppc@vger.kernel.org>; Thu, 06 Jan 2022 16:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1kNOBBJWV4zJS8HcYHpk7kQECqCPSScEopNDxozF4p4=;
        b=RByHUaq+mIc6q8K14rNcuw8hac6QEN8yr6i8199we3eKHoQJhlE5CAKSJDUbB0hxtA
         iR0pnuyxKtjzB1lu/RKyfR/FEVKI2xrjGaTcWxFD9KicWbZmn7ZUQD2hhOvznTEqReCF
         ZHV8j88jIFcklJE/QHTN+Xbo+/zPLVWIK0P/TuKbgYMvfEakMOOlqNL9G6hwQrX61frt
         Ic5tziMjQ2Tdp+GZsnfiKxOiRCLm+0oR3Og92B8xHMQiAMgjVrfz6RXA8ipwEzbo8PJ2
         g98qrcf79UoAENo1llT6MQlUgLjWkMSxyhMkx9sW0zeySxG+if2PgSPAM7W2ZVzDJd0r
         Ysqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1kNOBBJWV4zJS8HcYHpk7kQECqCPSScEopNDxozF4p4=;
        b=49uNabEoD0cv5xDMHXLwNRajIVQj/PI1mtw8xfdpZTz7Mgg9hpNK0saIUQE/blGSh9
         bbZ3qbrRkbLMlFT9o2wdeHDmMcU5ak4uURRCF7k9g3pXZAykWxjhkcvpwrS0sh2PoBFm
         NAw9GiMFZKRWnHlc68ZDFDH2W1B1ZNqgReMYdEweKiHeia4dOh8RG87EZbhpOBHYgXOc
         B9axwu4U/znyY2O8p7D19VU5dC/HuyX1arOZYKbmD4HbofmhENtkAMA2CoAP0mzWJ5fP
         eDbX1RWCFFlKyBITXYhA/GlPDG3X7LCrRVv7QGSOa3BpTN236iMbR9wtBMWRhhbippBH
         bSPw==
X-Gm-Message-State: AOAM532L1uScWx4LxD6mXQjTeaveZ3FLGgC78oROWmc4yEMJgFAf6IBn
        0IYVsIxSKxIHUZnVk9CHIJ5PSw==
X-Google-Smtp-Source: ABdhPJyDF6BN7+vp1sENXru8rXjc7zmWvq1Khm9qSOnSc8B+1qOs7zNr3w9qezB+gSEfwNNQ5YAjog==
X-Received: by 2002:a05:6a00:b8e:b0:4ba:cbf2:516e with SMTP id g14-20020a056a000b8e00b004bacbf2516emr63051141pfj.72.1641515075585;
        Thu, 06 Jan 2022 16:24:35 -0800 (PST)
Received: from [192.168.10.153] (203-7-124-83.dyn.iinet.net.au. [203.7.124.83])
        by smtp.gmail.com with ESMTPSA id e4sm1025122pjr.40.2022.01.06.16.24.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jan 2022 16:24:35 -0800 (PST)
Message-ID: <555dd74b-75ce-b87b-7ef1-5559af9e631e@ozlabs.ru>
Date:   Fri, 7 Jan 2022 11:24:29 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH v2 5/7] KVM: PPC: mmio: Queue interrupt at
 kvmppc_emulate_mmio
Content-Language: en-US
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com
References: <20220106200304.4070825-1-farosas@linux.ibm.com>
 <20220106200304.4070825-6-farosas@linux.ibm.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20220106200304.4070825-6-farosas@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 07/01/2022 07:03, Fabiano Rosas wrote:
> If MMIO emulation fails, we queue a Program interrupt to the
> guest. Move that line up into kvmppc_emulate_mmio, which is where we
> set RESUME_GUEST/HOST.
> 
> No functional change, just separation of responsibilities.
> 
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---
>   arch/powerpc/kvm/emulate_loadstore.c | 4 +---
>   arch/powerpc/kvm/powerpc.c           | 2 +-
>   2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/emulate_loadstore.c b/arch/powerpc/kvm/emulate_loadstore.c
> index 48272a9b9c30..ef50e8cfd988 100644
> --- a/arch/powerpc/kvm/emulate_loadstore.c
> +++ b/arch/powerpc/kvm/emulate_loadstore.c
> @@ -355,10 +355,8 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
>   		}
>   	}
>   
> -	if (emulated == EMULATE_FAIL) {
> +	if (emulated == EMULATE_FAIL)
>   		advance = 0;


You can now drop @advance by moving the "if" few lines down.


> -		kvmppc_core_queue_program(vcpu, 0);
> -	}
>   
>   	trace_kvm_ppc_instr(inst, kvmppc_get_pc(vcpu), emulated);
>   
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 3fc8057db4b4..a2e78229d645 100644
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

-- 
Alexey
