Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 662E7121F4B
	for <lists+kvm-ppc@lfdr.de>; Tue, 17 Dec 2019 01:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfLQAKF (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Dec 2019 19:10:05 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:46009 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbfLQAKE (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 16 Dec 2019 19:10:04 -0500
Received: by mail-pj1-f67.google.com with SMTP id r11so3720563pjp.12
        for <kvm-ppc@vger.kernel.org>; Mon, 16 Dec 2019 16:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fm2RyG6CGkzHW8a7NuvllbM/DfTN/yylWtMUK//qu0k=;
        b=TYu0kcbGr5DM5CqdA18Xi7ZAE+sJdrjhZTYdaBMUWGKP02XBTVNnafhy0prERiXdH6
         +DuocFZ0F8KhqnZfu2yZd0WfWO/c6whebTZzG/b0WY5DD8rT8t/aI9L7JZtqyOl+l7hn
         B8MDwdqJlcJioNFY/beNwEBzpEpASnbf4tgnymDTxxJi+i7MHqiOZGEEr9MNlj91EZ0B
         ZGQlAFzVnL5zr3F/mPtKPF5SMI6Gqe/3Qr50bixaJOlBwC0B0GXJM1hTuJZRXCJgAMH4
         vu7Q988WzcT9SNUkn/yyTFx599nghszzDrSemxOUUGa8eCm0vWmkYNwEbWLa+Ful7DRR
         qZEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=fm2RyG6CGkzHW8a7NuvllbM/DfTN/yylWtMUK//qu0k=;
        b=K+crkelQlyeYhaYcMABbvHkdtlsjmrirkaRIJKBfGin9WkHidiNws7tel59RyRXVeI
         5fZWp5GIllqpjT6seQLTdNunGUVB6T6MLT2whY5J+yIcuZXe1Jc1kg0E0bTPGlEU0Fjb
         3EF0ccDfXgzQHlQ468BLeECqc3/9zL+AevU0bCfkoj+a7LnYpNyPbWM/ucEhel9+jQ8s
         MOOuxf7iMLz/qgQhysiACdo5kZYCVhuYmh5BIoNaiE9b6M/qShxo2PHngGUsmAG8WNCM
         SHazfkrhqboc5NFhzBQui4M+vXgOrRlHSSIiX6bLVdNNnjYYXqu3mOwMbYeF1zZol1Km
         N7MQ==
X-Gm-Message-State: APjAAAV+/MlBV2YBxm5/cKLc3lV8horYETAlBquZWFL58R/E351ouLmG
        uRQdaKcXzpT/8H+83hbog9z6Qw==
X-Google-Smtp-Source: APXvYqxE6zMgg7dr/Lm/exQ+KKtq5Gll/t9qWrobQQXlnxlFR1FPDI8uUqKlF6o0IC0kVhWTeeqpBg==
X-Received: by 2002:a17:90a:b010:: with SMTP id x16mr2647746pjq.130.1576541403517;
        Mon, 16 Dec 2019 16:10:03 -0800 (PST)
Received: from [10.61.2.175] ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id t30sm23170009pgl.75.2019.12.16.16.10.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 16:10:02 -0800 (PST)
Subject: Re: [PATCH kernel v2 2/4] powerpc/pseries: Allow not having
 ibm,hypertas-functions::hcall-multi-tce for DDW
To:     Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Michael Anderson <andmike@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ram Pai <linuxram@us.ibm.com>
References: <20191216041924.42318-1-aik@ozlabs.ru>
 <20191216041924.42318-3-aik@ozlabs.ru> <878snbuax4.fsf@morokweng.localdomain>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Autocrypt: addr=aik@ozlabs.ru; keydata=
 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
Message-ID: <f76a9894-579d-5477-1682-1623eaa46be8@ozlabs.ru>
Date:   Tue, 17 Dec 2019 11:09:58 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <878snbuax4.fsf@morokweng.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 17/12/2019 10:07, Thiago Jung Bauermann wrote:
> 
> Alexey Kardashevskiy <aik@ozlabs.ru> writes:
> 
>> By default a pseries guest supports a H_PUT_TCE hypercall which maps
>> a single IOMMU page in a DMA window. Additionally the hypervisor may
>> support H_PUT_TCE_INDIRECT/H_STUFF_TCE which update multiple TCEs at once;
>> this is advertised via the device tree /rtas/ibm,hypertas-functions
>> property which Linux converts to FW_FEATURE_MULTITCE.
>>
>> FW_FEATURE_MULTITCE is checked when dma_iommu_ops is used; however
>> the code managing the huge DMA window (DDW) ignores it and calls
>> H_PUT_TCE_INDIRECT even if it is explicitly disabled via
>> the "multitce=off" kernel command line parameter.
>>
>> This adds FW_FEATURE_MULTITCE checking to the DDW code path.
>>
>> This changes tce_build_pSeriesLP to take liobn and page size as
>> the huge window does not have iommu_table descriptor which usually
>> the place to store these numbers.
>>
>> Fixes: 4e8b0cf46b25 ("powerpc/pseries: Add support for dynamic dma windows")
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> 
> Reviewed-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
> Tested-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
> 
> Some minor nits below. Feel free to ignore.
> 
>> @@ -146,25 +146,25 @@ static int tce_build_pSeriesLP(struct iommu_table *tbl, long tcenum,
>>  	int ret = 0;
>>  	long tcenum_start = tcenum, npages_start = npages;
>>
>> -	rpn = __pa(uaddr) >> TCE_SHIFT;
>> +	rpn = __pa(uaddr) >> tceshift;
>>  	proto_tce = TCE_PCI_READ;
>>  	if (direction != DMA_TO_DEVICE)
>>  		proto_tce |= TCE_PCI_WRITE;
>>
>>  	while (npages--) {
>> -		tce = proto_tce | (rpn & TCE_RPN_MASK) << TCE_RPN_SHIFT;
>> -		rc = plpar_tce_put((u64)tbl->it_index, (u64)tcenum << 12, tce);
>> +		tce = proto_tce | (rpn & TCE_RPN_MASK) << tceshift;
>> +		rc = plpar_tce_put((u64)liobn, (u64)tcenum << tceshift, tce);
> 
> Is it necessary to cast to u64 here? plpar_tce_put() takes unsigned long
> for both arguments.


Looked as an unrelated change. Small but still unrelated.


> 
>> @@ -261,16 +263,16 @@ static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
>>  	return ret;
>>  }
>>
>> -static void tce_free_pSeriesLP(struct iommu_table *tbl, long tcenum, long npages)
>> +static void tce_free_pSeriesLP(unsigned long liobn, long tcenum, long npages)
>>  {
>>  	u64 rc;
>>
>>  	while (npages--) {
>> -		rc = plpar_tce_put((u64)tbl->it_index, (u64)tcenum << 12, 0);
>> +		rc = plpar_tce_put((u64)liobn, (u64)tcenum << 12, 0);
> 
> Same comment regarding cast to u64.
> 
>> @@ -400,6 +402,20 @@ static int tce_setrange_multi_pSeriesLP(unsigned long start_pfn,
>>  	u64 rc = 0;
>>  	long l, limit;
>>
>> +	if (!firmware_has_feature(FW_FEATURE_MULTITCE)) {
>> +		unsigned long tceshift = be32_to_cpu(maprange->tce_shift);
>> +		unsigned long dmastart = (start_pfn << PAGE_SHIFT) +
>> +				be64_to_cpu(maprange->dma_base);
>> +		unsigned long tcenum = dmastart >> tceshift;
>> +		unsigned long npages = num_pfn << PAGE_SHIFT >>
>> +				be32_to_cpu(maprange->tce_shift);
> 
> Could use the tceshift variable here.


True, overlooked.
Thanks for the reviews!


> 
>> +		void *uaddr = __va(start_pfn << PAGE_SHIFT);
>> +
>> +		return tce_build_pSeriesLP(be32_to_cpu(maprange->liobn),
>> +				tcenum, tceshift, npages, (unsigned long) uaddr,
>> +				DMA_BIDIRECTIONAL, 0);
>> +	}
>> +
>>  	local_irq_disable();	/* to protect tcep and the page behind it */
>>  	tcep = __this_cpu_read(tce_page);
> 
> 
> --
> Thiago Jung Bauermann
> IBM Linux Technology Center
> 

-- 
Alexey
