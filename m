Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2ECB320392
	for <lists+kvm-ppc@lfdr.de>; Sat, 20 Feb 2021 04:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbhBTDu1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Feb 2021 22:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhBTDu0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Feb 2021 22:50:26 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4480AC061574
        for <kvm-ppc@vger.kernel.org>; Fri, 19 Feb 2021 19:49:46 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id y3so1217694plg.4
        for <kvm-ppc@vger.kernel.org>; Fri, 19 Feb 2021 19:49:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MTtEm/Y0VOa/b5EBj8XvY9zE3KkoRphlPPPIZgYOXss=;
        b=T3dpDkG/Q6/Br+Mp6OzUL8PLx52008q7f9xgK/rvcv/Lgc0sdkGjqavvNsJhf216BR
         U7tFqTkFXobJ3/GNyULf26YXenvBHo6n7/RPFo/0FrEsWg+C7vq4XwoMJ8SjxdzARxgq
         8f02broD6G6k7VR2ZlBWEjtDdmf55bSwpKVE1PnYtkq8Jrm95d5W63bnCCH0j7OZMzTv
         UkEuw3vhChlOn3TccBpbvM01ixa3ZHbt2DMgR/nhQ5F+quiiHJadlEJesuPX8Qv0WIn9
         gK3FRt7XuMzDKR6eQxW64ma/UyU120DlmWc6Lix8h2RHdH6oO1pg3wwuxnn77pA6jvpS
         Oq+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MTtEm/Y0VOa/b5EBj8XvY9zE3KkoRphlPPPIZgYOXss=;
        b=f5x4JuJ/K8myl9J9WSGZG9fk1cD0LIAK0P9BbfIG7ZxMLTfSfOcmfyGQYaYF+SqyDH
         p9YqulxST1/v7Gt1KS7xH9ZdA7m9VvOmEX/C5jZ6fqqMsS7OKIqGl5eGDiUIRzaIfprn
         BgYNj/8ZesHQ15PO0+KTotTwfwNiJpSO3i6tPxOtM1a49YQRMMpHGHvXCMMbwyJpvUHh
         jg1YH02Mc4rSYjfo2qUNe6y8ejZbwqBwRCbV6+vmJl+nfy88qr6zhLY+cM3AbE2auVN6
         7Maq6kBwsnLXUjFZslR9gVZUFPZhCWBlYVD2ZwzOwlhdCJEkbc7xCfb4LDGb3WRc67LZ
         mfsg==
X-Gm-Message-State: AOAM531v1MYjeKwamUD2tg5WJOx6HY4w+g8lr0hlgWc7+amZTd0z4DyZ
        Ik7tqQsDjiAK3dKcVjNmdbK4j5tLXsFUBQ==
X-Google-Smtp-Source: ABdhPJwkH1fgwfZ1W+e/AgqDfvNMArgbsMOrhh0MQiriloEGVt+iFIdx1tspLjxU828+tP2l/2q2cA==
X-Received: by 2002:a17:902:bd4a:b029:e1:1ccd:35b7 with SMTP id b10-20020a170902bd4ab02900e11ccd35b7mr12072979plx.30.1613792985123;
        Fri, 19 Feb 2021 19:49:45 -0800 (PST)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id q20sm10389081pgh.79.2021.02.19.19.49.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 19:49:44 -0800 (PST)
Subject: Re: [PATCH kernel] powerpc/iommu: Annotate nested lock for lockdep
To:     Frederic Barrat <fbarrat@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org
References: <20210216032000.21642-1-aik@ozlabs.ru>
 <49b1f5cb-107c-296f-c339-13e627a73d6d@linux.ibm.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Message-ID: <7eaa747c-ebe1-14db-20f0-f115f9b85ba7@ozlabs.ru>
Date:   Sat, 20 Feb 2021 14:49:39 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:85.0) Gecko/20100101
 Thunderbird/85.0
MIME-Version: 1.0
In-Reply-To: <49b1f5cb-107c-296f-c339-13e627a73d6d@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 18/02/2021 23:59, Frederic Barrat wrote:
> 
> 
> On 16/02/2021 04:20, Alexey Kardashevskiy wrote:
>> The IOMMU table is divided into pools for concurrent mappings and each
>> pool has a separate spinlock. When taking the ownership of an IOMMU group
>> to pass through a device to a VM, we lock these spinlocks which triggers
>> a false negative warning in lockdep (below).
>>
>> This fixes it by annotating the large pool's spinlock as a nest lock.
>>
>> ===
>> WARNING: possible recursive locking detected
>> 5.11.0-le_syzkaller_a+fstn1 #100 Not tainted
>> --------------------------------------------
>> qemu-system-ppc/4129 is trying to acquire lock:
>> c0000000119bddb0 (&(p->lock)/1){....}-{2:2}, at: 
>> iommu_take_ownership+0xac/0x1e0
>>
>> but task is already holding lock:
>> c0000000119bdd30 (&(p->lock)/1){....}-{2:2}, at: 
>> iommu_take_ownership+0xac/0x1e0
>>
>> other info that might help us debug this:
>>   Possible unsafe locking scenario:
>>
>>         CPU0
>>         ----
>>    lock(&(p->lock)/1);
>>    lock(&(p->lock)/1);
>> ===
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> ---
>>   arch/powerpc/kernel/iommu.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
>> index 557a09dd5b2f..2ee642a6731a 100644
>> --- a/arch/powerpc/kernel/iommu.c
>> +++ b/arch/powerpc/kernel/iommu.c
>> @@ -1089,7 +1089,7 @@ int iommu_take_ownership(struct iommu_table *tbl)
>>       spin_lock_irqsave(&tbl->large_pool.lock, flags);
>>       for (i = 0; i < tbl->nr_pools; i++)
>> -        spin_lock(&tbl->pools[i].lock);
>> +        spin_lock_nest_lock(&tbl->pools[i].lock, &tbl->large_pool.lock);
> 
> 
> We have the same pattern and therefore should have the same problem in 
> iommu_release_ownership().
> 
> But as I understand, we're hacking our way around lockdep here, since 
> conceptually, those locks are independent. I was wondering why it seems 
> to fix it by worrying only about the large pool lock. That loop can take 
> many locks (up to 4 with current config). However, if the dma window is 
> less than 1GB, we would only have one, so it would make sense for 
> lockdep to stop complaining. Is it what happened? In which case, this 
> patch doesn't really fix it. Or I'm missing something :-)


My rough undestanding is that when spin_lock_nest_lock is called first 
time, it does some magic with lockdep classes somewhere in 
__lock_acquire()/register_lock_class() and right after that the nested 
lock is not the same as before and it is annotated so  we cannot lock 
nested locks without locking the nest lock first and no (re)annotation 
is needed. I'll try to poke this code once again and see, it is just was 
easier with p9/nested which is gone for now because of little snow in 
one of the southern states :)


> 
>    Fred
> 
> 
> 
>>       iommu_table_release_pages(tbl);
>>

-- 
Alexey
