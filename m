Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4647E538A93
	for <lists+kvm-ppc@lfdr.de>; Tue, 31 May 2022 06:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243826AbiEaEcb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 31 May 2022 00:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243830AbiEaEc2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 31 May 2022 00:32:28 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BF160048
        for <kvm-ppc@vger.kernel.org>; Mon, 30 May 2022 21:32:24 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id u12-20020a17090a1d4c00b001df78c7c209so1316655pju.1
        for <kvm-ppc@vger.kernel.org>; Mon, 30 May 2022 21:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Lj78+57OxIdsv/oF3J9WA/PNzVhyeIKn7W1czERbqag=;
        b=o+DMsuMVQCXQYR9fPXnECOvmkMDH2oB0m4dmEuLK7V6NXwVj2TtnTdW/JDe3509qqf
         W6hZAeOKB4s8Z0HQE9oRwYGE3dTTEZLNHT//pbgmH+OMJwIa+ncOTs2WU6XnywilolDk
         epbQ0pOqI8U7iVajswAIehZie6NQMc5/2ztwV7LIUL+RSdhFO/cqybDElvG/LWMq9EgW
         vq/Wp0C1JP0f03F1r5C1IHj3zw4+7TGPtgMvwH/GGsPq+j2palmn7zELIZZLe2SPPjOw
         ZWH3MHAraT+JLGddRp9ipT45Q1vlfW6No4LsFmDERCSOyReRPkGSyehvxkiTwr63JYk0
         Sfhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Lj78+57OxIdsv/oF3J9WA/PNzVhyeIKn7W1czERbqag=;
        b=DzQwIU4uNQB1B1KAaMFT+AM/8ASWkKag7DVP9aKrU3bQu2D4w/BkFtc7wzAXoKG1gy
         58zfBzLJVC9DiCjjoDpX5lkIw8TYdt4AwySSE0xqmIUv2w1euimtXPY15VfZcyFCVpia
         pKzA31QS+sEpy8CGADGUQZCip8f8sOgTC5T82dBx2EeYOqySZ6vIqWZjl8N+CG8LIRM4
         cQp+zFBLCCaviar2wnxAyycVj5wi9IfU2cxiCLPdoXekx/rI42NqKUHifD/743TfoDLY
         +Oiy1A7Hhc7m/BRURfRC68bTKLi5/YfxhuiOTSQ3uqJ3y9SOqF/nUqcvPrBmAQfh/wUY
         HJPA==
X-Gm-Message-State: AOAM531GS7h8quRS5O0Hm2/efjVaJC/yzkGWVE1N4LtMaF/KdMGvEOTU
        Rbz3mpy1VlOH1NviMsUHIc5uNtCgOLFDDQ==
X-Google-Smtp-Source: ABdhPJydKv9YorNTdsD67S1qS8tXuSWYx/ALgHI7oRKsu4y3gOPJ3hZRMMtRW9LF+en+6ZNcLZh8KQ==
X-Received: by 2002:a17:90a:2f84:b0:1dd:940:50e7 with SMTP id t4-20020a17090a2f8400b001dd094050e7mr26402359pjd.210.1653971543951;
        Mon, 30 May 2022 21:32:23 -0700 (PDT)
Received: from [10.61.2.177] (110-175-254-242.static.tpgi.com.au. [110.175.254.242])
        by smtp.gmail.com with ESMTPSA id v10-20020aa7808a000000b005187f4ebd12sm6448241pff.123.2022.05.30.21.32.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 21:32:23 -0700 (PDT)
Message-ID: <24c22c5c-2656-d590-2ae2-adfe0d3fd113@ozlabs.ru>
Date:   Tue, 31 May 2022 14:32:18 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:101.0) Gecko/20100101
 Thunderbird/101.0
Subject: Re: [PATCH kernel] KVM: Don't null dereference ops->destroy
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
References: <20220524055208.1269279-1-aik@ozlabs.ru>
 <Yo05tuQZorCO/kc0@google.com>
 <cc19c541-0b5b-423e-4323-493fd8dafdd8@ozlabs.ru>
 <6d291eba-1055-51c3-f015-d029a434b2c0@ozlabs.ru>
 <4fdbe38d-0e7d-764f-beab-034a9f172137@redhat.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <4fdbe38d-0e7d-764f-beab-034a9f172137@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 5/25/22 17:47, Paolo Bonzini wrote:
> On 5/25/22 04:58, Alexey Kardashevskiy wrote:
>>>>
>>
>>
>> After reading
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2bde9b3ec8bdf60788e9e and neighboring commits, it sounds that each create() should be paired with either destroy() or release() but not necessarily both.
> 
> I agree, if release() is implemented then destroy() will never be called 
> (except in error situations).
> 
> kvm_destroy_devices() should not be touched, except to add a WARN_ON 
> perhaps.

I'll leave it as is.

> 
>> So I'm really not sure dummy handlers is a good idea. Thanks,
> 
> But in that case shouldn't kvm_ioctl_create_device also try 
> ops->release, i.e.
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6d971fb1b08d..f265e2738d46 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4299,8 +4299,11 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
>           kvm_put_kvm_no_destroy(kvm);
>           mutex_lock(&kvm->lock);
>           list_del(&dev->vm_node);
> +        if (ops->release)
> +            ops->release(dev);
>           mutex_unlock(&kvm->lock);
> -        ops->destroy(dev);
> +        if (ops->destroy)
> +            ops->destroy(dev);


btw why is destroy() not under the kvm->lock here? The comment in 
kvm_destroy_devices() suggests that it is an exception there but not 
necessarily here. Thanks,



>           return ret;
>       }
> 
> ?
> 
> Paolo
> 

-- 
Alexey
