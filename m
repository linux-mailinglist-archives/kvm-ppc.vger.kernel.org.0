Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA103FE86B
	for <lists+kvm-ppc@lfdr.de>; Thu,  2 Sep 2021 06:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhIBE0G (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 2 Sep 2021 00:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhIBE0G (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 2 Sep 2021 00:26:06 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66A4C061575
        for <kvm-ppc@vger.kernel.org>; Wed,  1 Sep 2021 21:25:08 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso540978pjh.5
        for <kvm-ppc@vger.kernel.org>; Wed, 01 Sep 2021 21:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=o/fdA9EiQAmnjCZwLE6dEup3eAwqC+a9XVZ0mxlaGiM=;
        b=RxbL8dN2qZkf2mEv2PmrK4gxrU8XmkYq8nc1/8Kvb3SVXXcPYRbTkkjcWCWqR/Qm14
         Vt7XAcc/y1RrzND0fZwF69pUbP8yZJNc2m9/gt2NIs2xkhABxvVTEf2P7Pbmsd2O2Egv
         AQi9sZvGKgshwe4seCdOJ1iqigt1AWzyVCkC1mROqMj/ybHleMbZ6980qm7GxGHaSOA+
         MWtbpQ6674CECRxd1L/dDDV+U+l7Je8cmA1hGHrvYrry5j60pZfkTKlOJNAW0qrbNgRY
         d3solZPvG6Wl6nVj+9e/qY48RraFq/mojIED4S7Dw9JRHLaw7vL6rz9FVL2iDs8QXDlr
         GApw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=o/fdA9EiQAmnjCZwLE6dEup3eAwqC+a9XVZ0mxlaGiM=;
        b=NxAGdkxEo2vR9kPeKEZMrV8JSaQOeDj6E2mUX6HnmXgv/QG/7wT5lW+OZ8y//oW8Hu
         0D8GOTvyTvvzPgGsT1cgs+TAARE85AXITNkfNvJF5qZ1EsWaTv5ED1QHjtIuEdW457Vy
         qfy/FkzinembLyAS03pY2EShyiIb2cE8j1Qa3vHXQXuwzWnwpm5VYwyYiVJftr7kERTR
         xrxQP4RiBLg921OkxrTMzZVzE4ehFG0EK94AhsKKQjqX8FH6qx1heoLpdcgdaHI8Zm1i
         hR2IBVnKZkezzayAC+2tH37iOmtrSCW8znYJRorBEkOlfoQS/hcQaY+bnN/DoE/1ihh7
         iznA==
X-Gm-Message-State: AOAM531vEf5eDgnqINL/+wS0N7EmUkq+QCd6m5srLDeRJGBWfJ/QlW1r
        bHGlLQ1BFoJqv9kK+8NDikJSStME5BnPEQ==
X-Google-Smtp-Source: ABdhPJwcbWkTnTvfgneRQA2NLuCqjbeOV7NKEUCvFLXhAVerLpVk540v9Y8BlwnhrT4TAhyL2WUeYQ==
X-Received: by 2002:a17:90a:b795:: with SMTP id m21mr1483001pjr.143.1630556708274;
        Wed, 01 Sep 2021 21:25:08 -0700 (PDT)
Received: from [192.168.10.23] (124-171-108-209.dyn.iinet.net.au. [124.171.108.209])
        by smtp.gmail.com with ESMTPSA id c123sm526061pfc.50.2021.09.01.21.25.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 21:25:07 -0700 (PDT)
Message-ID: <a72edcd2-a990-a549-2f31-dab134bef6a6@ozlabs.ru>
Date:   Thu, 2 Sep 2021 14:25:03 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:92.0) Gecko/20100101
 Thunderbird/92.0
Subject: Re: [PATCH kernel] KVM: PPC: Book3S: Suppress warnings when
 allocating too big memory slots
Content-Language: en-US
To:     Fabiano Rosas <farosas@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org
References: <20210901084512.1658628-1-aik@ozlabs.ru>
 <87fsuouysc.fsf@linux.ibm.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <87fsuouysc.fsf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 02/09/2021 00:59, Fabiano Rosas wrote:
> Alexey Kardashevskiy <aik@ozlabs.ru> writes:
> 
>> The userspace can trigger "vmalloc size %lu allocation failure: exceeds
>> total pages" via the KVM_SET_USER_MEMORY_REGION ioctl.
>>
>> This silences the warning by checking the limit before calling vzalloc()
>> and returns ENOMEM if failed.
>>
>> This does not call underlying valloc helpers as __vmalloc_node() is only
>> exported when CONFIG_TEST_VMALLOC_MODULE and __vmalloc_node_range() is not
>> exported at all.
>>
>> Spotted by syzkaller.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> ---
>>   arch/powerpc/kvm/book3s_hv.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index 474c0cfde384..a59f1cccbcf9 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -4830,8 +4830,12 @@ static int kvmppc_core_prepare_memory_region_hv(struct kvm *kvm,
>>   	unsigned long npages = mem->memory_size >> PAGE_SHIFT;
>>
>>   	if (change == KVM_MR_CREATE) {
>> -		slot->arch.rmap = vzalloc(array_size(npages,
>> -					  sizeof(*slot->arch.rmap)));
>> +		unsigned long cb = array_size(npages, sizeof(*slot->arch.rmap));
> 
> What does cb mean?

"count of bytes"

This is from my deep Windows past :)

https://docs.microsoft.com/en-us/windows/win32/stg/coding-style-conventions


> 
>> +
>> +		if ((cb >> PAGE_SHIFT) > totalram_pages())
>> +			return -ENOMEM;
>> +
>> +		slot->arch.rmap = vzalloc(cb);
>>   		if (!slot->arch.rmap)
>>   			return -ENOMEM;
>>   	}

-- 
Alexey
