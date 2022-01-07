Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9796486F6D
	for <lists+kvm-ppc@lfdr.de>; Fri,  7 Jan 2022 02:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345057AbiAGBIv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Jan 2022 20:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiAGBIt (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Jan 2022 20:08:49 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B9AC061245
        for <kvm-ppc@vger.kernel.org>; Thu,  6 Jan 2022 17:08:49 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id b22so3894437pfb.5
        for <kvm-ppc@vger.kernel.org>; Thu, 06 Jan 2022 17:08:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Ouy0zNLVVIhFTQ9/jbGwNZKkMA9lx/bmMEnsS2uflqw=;
        b=15v9dLePGXMI4QIcJawAT+kO4viyJZUBpg8N8tyVxwzzfav4rVfgIhAcB5AWeU382C
         zZK9OeObmFqDGp75MZrUR++A2OCxh/EYtKFYGRKjj8zH8OZsv0HHVKzlKTUiKh3nAvui
         x/F0UgEiyoX6TVH8axGpW9Lpe3L+MnxUdKoynfZkPh2sgCBrpfmK6oic16bHxpb+uS8u
         1CwsFgSHYaKm9dYt6WfHOSRUFk+192J+08tC/UYlAPH28tY+X/fFrQHZBgC174N/411y
         KmgfJ+vbIP6pL92CmXs5Myt5J2y7TkNZe1/TYGuQymhWBvsSjoNaiSqUAE9qRMaUQeiF
         c2HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ouy0zNLVVIhFTQ9/jbGwNZKkMA9lx/bmMEnsS2uflqw=;
        b=RaHyOo1/iDJWs2QvRW2HmwSq+e+BejT8RbpjNmHON4DuwCzq5G8/BLH94CKJeGWDyK
         wWWKTMLmUSmdYlj9SayCTU2cI5KlOwrEuFQneBYLL9bpx3otDyqjJ9owJ+fIEzmTzb9t
         9c5TAqxn5BiRrwQQM7heA4nT7Q7h0GOr06fE//GcJFqHW/wL6tF+ovHizWFwd4AWMMX4
         OAmOM52zpgNXiaOSbECWykXaEyByrlnBTd+itbZwwyM3a3I2OH7n3u3kDs9XjZs7yKww
         PVcW82bQ7nC3BsrebM6FLzOo/NzADpT1J49T2ZJq4QT9rl/8JQK0Np2QxIeiuVmT2ah6
         0Q6Q==
X-Gm-Message-State: AOAM5303RtFcao9En8H6qQt5ILT8Pp342NDVytJADVd+L54s21U+5ys7
        l4zqaAYpVZP5nYvHDlPYzZpD/Q==
X-Google-Smtp-Source: ABdhPJzq2JGQZjdR5OGk9J9NlgdjAcggzbH/xZlIMngI0QE7KIEVYc+ZlOjit/MR4mnM4y0EasaNYQ==
X-Received: by 2002:a05:6a00:216f:b0:49f:dcb7:2bf2 with SMTP id r15-20020a056a00216f00b0049fdcb72bf2mr62778701pff.19.1641517729011;
        Thu, 06 Jan 2022 17:08:49 -0800 (PST)
Received: from [192.168.10.153] (203-7-124-83.dyn.iinet.net.au. [203.7.124.83])
        by smtp.gmail.com with ESMTPSA id s18sm356768pjq.56.2022.01.06.17.08.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jan 2022 17:08:48 -0800 (PST)
Message-ID: <63f9a19c-0b5c-8746-7ef4-ab72cbda397c@ozlabs.ru>
Date:   Fri, 7 Jan 2022 12:08:42 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH v2 6/7] KVM: PPC: mmio: Return to guest after emulation
 failure
Content-Language: en-US
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com
References: <20220106200304.4070825-1-farosas@linux.ibm.com>
 <20220106200304.4070825-7-farosas@linux.ibm.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20220106200304.4070825-7-farosas@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 07/01/2022 07:03, Fabiano Rosas wrote:
> If MMIO emulation fails we don't want to crash the whole guest by
> returning to userspace.
> 
> The original commit bbf45ba57eae ("KVM: ppc: PowerPC 440 KVM
> implementation") added a todo:
> 
>    /* XXX Deliver Program interrupt to guest. */
> 
> and later the commit d69614a295ae ("KVM: PPC: Separate loadstore
> emulation from priv emulation") added the Program interrupt injection
> but in another file, so I'm assuming it was missed that this block
> needed to be altered.
> 
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>


Looks right.
Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>

but this means if I want to keep debugging those kvm selftests in 
comfort, I'll have to have some exception handlers in the vm as 
otherwise the failing $pc is lost after this change :)

> ---
>   arch/powerpc/kvm/powerpc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index a2e78229d645..50e08635e18a 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -309,7 +309,7 @@ int kvmppc_emulate_mmio(struct kvm_vcpu *vcpu)
>   		kvmppc_get_last_inst(vcpu, INST_GENERIC, &last_inst);
>   		kvmppc_core_queue_program(vcpu, 0);
>   		pr_info("%s: emulation failed (%08x)\n", __func__, last_inst);
> -		r = RESUME_HOST;
> +		r = RESUME_GUEST;
>   		break;
>   	}
>   	default:

-- 
Alexey
