Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DC3321069
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Feb 2021 06:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhBVFZd (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Feb 2021 00:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhBVFZa (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Feb 2021 00:25:30 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91301C061574
        for <kvm-ppc@vger.kernel.org>; Sun, 21 Feb 2021 21:24:50 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id x129so1169243pfx.7
        for <kvm-ppc@vger.kernel.org>; Sun, 21 Feb 2021 21:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hGeA39Rok1Cc1GkXN/XsuF5wpXfilzhhdTN9JhuPtls=;
        b=oaaBO+mfEFM25ZERc3s7+iEktqRZRqAMjck7fQgZnhegMGc1ISqPx3NMmgAzjN3P3f
         OoQzjLUEWR8PsrZrWhyf+8R0s6e0YHhzW8XbV7SUm7jnQZ7S1jCXsV4LzFKNy/8DUfdx
         HrFo3ntl8qhqc9GkaJ+kr+jhlt4pkPx2bjTKBL8O36su35jBMdtjn7ifdUhkP1AAx9g7
         h9BjmdGf0IVkTw3rLUMqwuG2Cq0tUuuI77Imy2XDqOO1a9KQQY3AhUDOjRt76GA5gZ0G
         C80OQ8Hg84OVYS1yXQGTCPh6poREWUKwenQWzaX3Aez5yXdkyptanZUX0XtAc/hN4OK+
         kY+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hGeA39Rok1Cc1GkXN/XsuF5wpXfilzhhdTN9JhuPtls=;
        b=aWVrVdGNWXXXobkNqTtxLzvmT4EOJzh9ZnnEyfnDyT321/7AKBhyaTxiQpZXjnNfwP
         0GW6G72kACvDxMwp1zxzL67Nn1sUHkUBrQfdL7VVCbdCwiS7ArDGDZ6z+cebIUiEJTl5
         7gxFAMkNSN/+4kGXhlHD0cAtH6zUkDaTU87fYzW/EXjcroOtq4xw9zPsxY7GoeQ5bSS8
         /6AJYi2bNVTRC+h371v1MoD1HgF0ldr79ZZ+W7QSZSSFutOYyNt/R6/ciU56UM0qWAuh
         U7Csp56vP3a6+h0zmxR1kO7rDR2ZYb+3WZp3SSmotGK0v37mdpEBGrQHpDTDlsN+ox4N
         nxOA==
X-Gm-Message-State: AOAM530QwubCyC5edm285rq4k3vm8FFB4J3JwyWGWVZ05L+Kw/oUuFSa
        fIdbTmUaKAb+Z7gX8HGxxWKL5g==
X-Google-Smtp-Source: ABdhPJxNk9Pd3nA62RWz6+kIvbT5QFldMlVKropgQt/S+hIVbDXlL89lwblbQ29BTYfS/OicHZOTEw==
X-Received: by 2002:a63:f10b:: with SMTP id f11mr18942520pgi.248.1613971489748;
        Sun, 21 Feb 2021 21:24:49 -0800 (PST)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id br2sm1877800pjb.40.2021.02.21.21.24.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 21:24:49 -0800 (PST)
Subject: Re: [PATCH kernel 2/2] powerpc/iommu: Do not immediately panic when
 failed IOMMU table allocation
To:     Leonardo Bras <leobras.c@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
References: <20210216033307.69863-1-aik@ozlabs.ru>
 <20210216033307.69863-3-aik@ozlabs.ru>
 <433396d9ef216aa090e32bb344d42f60de1fb9aa.camel@gmail.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Message-ID: <0ae74efe-8b9a-566a-d984-8e5b662ff330@ozlabs.ru>
Date:   Mon, 22 Feb 2021 16:24:44 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:85.0) Gecko/20100101
 Thunderbird/85.0
MIME-Version: 1.0
In-Reply-To: <433396d9ef216aa090e32bb344d42f60de1fb9aa.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 18/02/2021 06:32, Leonardo Bras wrote:
> On Tue, 2021-02-16 at 14:33 +1100, Alexey Kardashevskiy wrote:
>> Most platforms allocate IOMMU table structures (specifically it_map)
>> at the boot time and when this fails - it is a valid reason for panic().
>>
>> However the powernv platform allocates it_map after a device is returned
>> to the host OS after being passed through and this happens long after
>> the host OS booted. It is quite possible to trigger the it_map allocation
>> panic() and kill the host even though it is not necessary - the host OS
>> can still use the DMA bypass mode (requires a tiny fraction of it_map's
>> memory) and even if that fails, the host OS is runnnable as it was without
>> the device for which allocating it_map causes the panic.
>>
>> Instead of immediately crashing in a powernv/ioda2 system, this prints
>> an error and continues. All other platforms still call panic().
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> 
> Hello Alexey,
> 
> This looks like a good change, that passes panic() decision to platform
> code. Everything looks pretty straightforward, but I have a question
> regarding this:
> 
>> @@ -1930,16 +1931,16 @@ static long pnv_pci_ioda2_setup_default_config(struct pnv_ioda_pe *pe)
>>   		res_start = pe->phb->ioda.m32_pci_base >> tbl->it_page_shift;
>>   		res_end = min(window_size, SZ_4G) >> tbl->it_page_shift;
>>   	}
>> -	iommu_init_table(tbl, pe->phb->hose->node, res_start, res_end);
>> -	rc = pnv_pci_ioda2_set_window(&pe->table_group, 0, tbl);
>>
>> +	if (iommu_init_table(tbl, pe->phb->hose->node, res_start, res_end))
>> +		rc = pnv_pci_ioda2_set_window(&pe->table_group, 0, tbl);
>> +	else
>> +		rc = -ENOMEM;
>>   	if (rc) {
>> -		pe_err(pe, "Failed to configure 32-bit TCE table, err %ld\n",
>> -				rc);
>> +		pe_err(pe, "Failed to configure 32-bit TCE table, err %ld\n", rc);
>>   		iommu_tce_table_put(tbl);
>> -		return rc;
>> +		tbl = NULL; /* This clears iommu_table_base below */
>>   	}
>> -
>>   	if (!pnv_iommu_bypass_disabled)
>>   		pnv_pci_ioda2_set_bypass(pe, true);
>>   
>>
> 
> If I could understand correctly, previously if iommu_init_table() did
> not panic(), and pnv_pci_ioda2_set_window() returned something other
> than 0, it would return rc in the if (rc) clause, but now it does not
> happen anymore, going through if (!pnv_iommu_bypass_disabled) onwards.
> 
> Is that desired?


Yes. A PE (==device, pretty much) has 2 DMA windows:
- the default one which requires some RAM to operate
- a bypass mode which tells the hardware that PCI addresses are 
statically mapped to RAM 1:1.

This bypass mode does not require extra memory to work and is used in 
the most cases on the bare metal as long as the device supports 64bit 
DMA which is everything except GPUs. Since it is cheap to enable and 
this what we prefer anyway, no urge to fail.


> As far as I could see, returning rc there seems a good procedure after
> iommu_init_table returning -ENOMEM.

This change is intentional and yes it could be done by a separate patch 
but I figured there is no that much value in splitting.



-- 
Alexey
