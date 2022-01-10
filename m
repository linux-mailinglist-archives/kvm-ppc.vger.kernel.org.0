Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027E948A3FA
	for <lists+kvm-ppc@lfdr.de>; Tue, 11 Jan 2022 00:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242563AbiAJXvJ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 10 Jan 2022 18:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345770AbiAJXvI (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 10 Jan 2022 18:51:08 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76841C06173F
        for <kvm-ppc@vger.kernel.org>; Mon, 10 Jan 2022 15:51:08 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id ie23-20020a17090b401700b001b38a5318easo2579212pjb.2
        for <kvm-ppc@vger.kernel.org>; Mon, 10 Jan 2022 15:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=g4elZEGZLbtyoXvKlR1aoQZ5uI6OqTEZ0ihc5xTsWHM=;
        b=ItfE+s4nge1QQhJwmD9D/rdEqltMHF12wvZaPS8mrC5P0AfKtOnkchOoqnXnZBifON
         2z91S6wROPs07mjG33MJo4E1GGPBBJBfKgkDX7eCJFnOhtkTcSvIvlJh0kPcrtXInEWh
         C7tUwT3v7e4qw+9i3eEpNNQwEQhjCocgK0HQSkqnW8Bz7Xu6G7qJOz5hfomibP1HVOAD
         5udnVVxeCHsIiiHSXYXGeYbL65owzDTmK9D932PPoCJrjHBOjpKAuu5EBswTi+hMdZkz
         hnQy5qefk5l8yw6kq0T7ZOZQ3phWmKJ+e74GKwpQeDHAhZNWz1EnDbv6lOi+buVOwHfS
         OpzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=g4elZEGZLbtyoXvKlR1aoQZ5uI6OqTEZ0ihc5xTsWHM=;
        b=77VpHsG/0MVD0YtD1G5g9oneR+bmxILBsEA+t8T5+QyFg9KY7edbCzKxJBKC0IFSMn
         MeDfq6pwMTw/Z+8QFuiMEmO+pExgi8sCWm7v1cR6fj/e3/N7HMPbjNCJFI9oU5Ne1pbU
         20zvvhN2KwL264s29+QxmWLH6T4j+0ACCP99kdKWzzaGL5mGSod7mesaR4O4ZgrdQm62
         eFi1JqMUOrzf19aF+CcH6i7qbl84uCCq3JjlgQTx1CSsPQT7L10hNfhh5AGD6Hc44pvw
         tnEK3ZAs0T9FzbKsaBCk35vd4GWzyQIjlYsqa8Jd0E/kPBz9mtABX29c1IJfpupwUX5I
         qhMg==
X-Gm-Message-State: AOAM531a8ouKWzuljWgQJo+7dlHORFRfzq/RbdzRYENSRt75s5Z1VBFD
        G6Z4otkxud12+jI3VXhoQ21RAQ==
X-Google-Smtp-Source: ABdhPJz3Oz+IIfqsYM3c7rT02Fu1G6CWKBEK2E2E7ymL5UvrtkLHrNNpLQcnI6qolCJ+dps09CJ8Bw==
X-Received: by 2002:a05:6a00:1693:b0:44c:64a3:d318 with SMTP id k19-20020a056a00169300b0044c64a3d318mr2041347pfc.81.1641858667919;
        Mon, 10 Jan 2022 15:51:07 -0800 (PST)
Received: from [192.168.10.24] (203-7-124-83.dyn.iinet.net.au. [203.7.124.83])
        by smtp.gmail.com with ESMTPSA id l13sm37253pgq.34.2022.01.10.15.51.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 15:51:07 -0800 (PST)
Message-ID: <bf61f021-15b3-7093-f991-cdcda93d059d@ozlabs.ru>
Date:   Tue, 11 Jan 2022 10:51:02 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH v3 5/6] KVM: PPC: mmio: Return to guest after emulation
 failure
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20220107210012.4091153-1-farosas@linux.ibm.com>
 <20220107210012.4091153-6-farosas@linux.ibm.com>
 <1641799578.6dxlxsaaos.astroid@bobo.none>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <1641799578.6dxlxsaaos.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 1/10/22 18:36, Nicholas Piggin wrote:
> Excerpts from Fabiano Rosas's message of January 8, 2022 7:00 am:
>> If MMIO emulation fails we don't want to crash the whole guest by
>> returning to userspace.
>>
>> The original commit bbf45ba57eae ("KVM: ppc: PowerPC 440 KVM
>> implementation") added a todo:
>>
>>    /* XXX Deliver Program interrupt to guest. */
>>
>> and later the commit d69614a295ae ("KVM: PPC: Separate loadstore
>> emulation from priv emulation") added the Program interrupt injection
>> but in another file, so I'm assuming it was missed that this block
>> needed to be altered.
>>
>> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
>> Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> ---
>>   arch/powerpc/kvm/powerpc.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
>> index 6daeea4a7de1..56b0faab7a5f 100644
>> --- a/arch/powerpc/kvm/powerpc.c
>> +++ b/arch/powerpc/kvm/powerpc.c
>> @@ -309,7 +309,7 @@ int kvmppc_emulate_mmio(struct kvm_vcpu *vcpu)
>>   		kvmppc_get_last_inst(vcpu, INST_GENERIC, &last_inst);
>>   		kvmppc_core_queue_program(vcpu, 0);
>>   		pr_info("%s: emulation failed (%08x)\n", __func__, last_inst);
>> -		r = RESUME_HOST;
>> +		r = RESUME_GUEST;
> 
> So at this point can the pr_info just go away?
> 
> I wonder if this shouldn't be a DSI rather than a program check.
> DSI with DSISR[37] looks a bit more expected. Not that Linux
> probably does much with it but at least it would give a SIGBUS
> rather than SIGILL.

It does not like it is more expected to me, it is not about wrong memory 
attributes, it is the instruction itself which cannot execute.

DSISR[37]:
Set to 1 if the access is due to a lq, stq, lwat, ldat, lbarx, lharx, 
lwarx, ldarx, lqarx, stwat,
stdat, stbcx., sthcx., stwcx., stdcx., or stqcx. instruction that 
addresses storage that is Write
Through Required or Caching Inhibited; or if the access is due to a copy 
or paste. instruction
that addresses storage that is Caching Inhibited; or if the access is 
due to a lwat, ldat, stwat, or
stdat instruction that addresses storage that is Guarded; otherwise set 
to 0.
