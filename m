Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D514322518
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Feb 2021 06:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhBWFOf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 23 Feb 2021 00:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbhBWFOd (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 23 Feb 2021 00:14:33 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC652C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Feb 2021 21:13:53 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id s23so1102907pji.1
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Feb 2021 21:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4SffRHLtG7nt3Ltmt3Tr3+tyegiAH2nuFv/zbGJURFw=;
        b=vUn3khT6E1bYKUjq2DtR3Tutqszv2qikitpA+XiBjOiC9bp75bv3W+Ieswo7noGPFb
         x2iUzyJHoXmbBeG5L9uF5hcPZ8H9E2EYT7c23w7w0k/wC4ORarSdhOFlYhacomihrBL8
         JFZjo1eiJ99YKzT1FGpnfZr/MKniT+dmtxXBUxQgIJmB3KT7e1HUrOKiwRzOXqWGolGE
         SNgqalz79NB0aFx/Zuj3Z3YqH5ILodY0NMGSiPu9RsJe5qWBwUkB0LHuHhUSjBjS81LZ
         SCjLeUlfcQaT8EkM885b/tK2yPNcGl6L3kvNJVORr2KJUwHQs4O1cjoPXfkh6BObzS85
         XLgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4SffRHLtG7nt3Ltmt3Tr3+tyegiAH2nuFv/zbGJURFw=;
        b=n1RRrhDaEocoe2J/xdUn/Fm+diwmlTEVFzm8DlmLHf6wmu6iNKIqAr5Mm6xh1zmT6o
         XJ9qzoH1RVOH/pYQC9OLN8omlslBUwVcVK1uekVqwnSaBy0FtcjT6OHgwrrHNwrRg+FC
         JUhsWNdqOMLfeQPLejbcWdAlnLOpMZPm+MP/sUis3yWfxkBz+vLzI5bZO3KWkF9hJqFC
         NTvUyhQPaxZe/JhCWTDCodFCEFo6FEV6yVD39EsWKGy3SLfKDKglGSOmpZnRROMvJQaV
         UA57QqDq0binANG9tzgAjbCTzvl6Y7Rv2eIfSJAR/JsQog6OzwtKN6Z84glytS0/7c4G
         PgkQ==
X-Gm-Message-State: AOAM531iUak5F1aHk5HgvgGmpUTBLdumJjf8J/hBE+mLBEyQ1GheIcrY
        VuOI14GsvjMBCKv5JN6JFnPM1gyq4mVmdA==
X-Google-Smtp-Source: ABdhPJxEC2GMFlE4kvJhqEFeUTcumwzH4cEMd7lfXdWcOZ3dBmoKOivRTt617cE9HIcam10fwOLeJg==
X-Received: by 2002:a17:90a:eac4:: with SMTP id ev4mr13946489pjb.146.1614057232966;
        Mon, 22 Feb 2021 21:13:52 -0800 (PST)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id a19sm20218956pff.186.2021.02.22.21.13.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 21:13:52 -0800 (PST)
Subject: Re: [PATCH kernel] powerpc/iommu: Annotate nested lock for lockdep
To:     Frederic Barrat <fbarrat@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org
References: <20210216032000.21642-1-aik@ozlabs.ru>
 <49b1f5cb-107c-296f-c339-13e627a73d6d@linux.ibm.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Message-ID: <0804cbd0-7acc-3c9b-3626-4149dcd03f8b@ozlabs.ru>
Date:   Tue, 23 Feb 2021 16:13:49 +1100
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
> to fix it by worrying only about the large pool lock.

This is the other way around - we telling the lockdep not to worry about 
small pool locks if the nest lock (==large pool lock) is locked. The 
warning is printed when a nested lock is detected and the lockdep checks 
if there is a nest for this nested lock at check_deadlock().


> That loop can take 
> many locks (up to 4 with current config). However, if the dma window is 
> less than 1GB, we would only have one, so it would make sense for 
> lockdep to stop complaining.

Why would it stop if the large pool is always there?

> Is it what happened? In which case, this 
> patch doesn't really fix it. Or I'm missing something :-)

I tried with 1 or 2 small pools, no difference at all. I might also be 
missing something here too :)


> 
>    Fred
> 
> 
> 
>>       iommu_table_release_pages(tbl);
>>

-- 
Alexey
