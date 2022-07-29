Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27EB5849AE
	for <lists+kvm-ppc@lfdr.de>; Fri, 29 Jul 2022 04:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbiG2CWB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 28 Jul 2022 22:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbiG2CWA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 28 Jul 2022 22:22:00 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEDE79EE7
        for <kvm-ppc@vger.kernel.org>; Thu, 28 Jul 2022 19:21:55 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d10so3445452pfd.9
        for <kvm-ppc@vger.kernel.org>; Thu, 28 Jul 2022 19:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yL6IUYgPwNHI0oBre6USbbEJkgU31+NcKUw2BdyBE+k=;
        b=eae2cICrCe2DgCX9GLFxTBoteiX4MJieAZaKj/FXNBqqz+kA0xbDQcfLyg2/L4nHSi
         GXqHA7bdjUh4pkjMAYqmthaac6V2RLFoI3Cb+GcNJUXMdiUJ+cI3vrsW94gt8pZfl+CB
         ae/l8S0Vy/hAaH65jA1y7eFyMZm4wOomontpwLkGmWRSercl7oVyxK1CAnu7lZBd1oQr
         miLqBni30Wy0l+0UDEoUYM21qkgfiLz9D8fjJNxQOyCDUKyiwP+wFyXka41X2X9at+rX
         imxyd3XpBaseiIBZX965xQaeA6VrkrPD/B2CJOwW2O/BdkZhvJW6qG2eCHHgKsRAkeDw
         Edgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yL6IUYgPwNHI0oBre6USbbEJkgU31+NcKUw2BdyBE+k=;
        b=JmVs+evWa9R3HbgJkTaAngVPNtbwbocvHHtF7fZzWRrymS2G1CS6e9ZjMDq74B/3nA
         dsQmTMVF+vNRmEZKAvbG0o1vRYoMAUCIwiLgezkWi4BF21BzQmiCNz10xJ8I4FA8AH7Y
         a0fkQ18psngUX98GRFp9mJHU6f6JDsWlHa7uGv648mujBa+DFm1MSDbwdYiuGuNQRdWt
         8NVtdF+ZraKzLoK5sBFP3/fPSIB5vrjvjlzfDLSSlRtcKbCV9psRFkcZ8IXD7scKvNFn
         2tJ4OMsSEHLQDabDy9dyfKOsNSHGHi/328Q9bjAjowQvsORckWmQU+acc4F6sYtsAxLn
         HpKA==
X-Gm-Message-State: ACgBeo3/s8XQAEn9iHEhSQtxsLBZi/Wwz7ZnFgCZu7tOKhpAAfPqVHxA
        7lhWe0mpuW4Z8shv2A7HmlnvUg==
X-Google-Smtp-Source: AGRyM1vhohbLpRcd05Kr+trC+ZuYAaJC08xuSgp+1X8NvEUQTHTDYL63DHsK5CMUWvyhk7tt2yKF8g==
X-Received: by 2002:a05:6a00:3388:b0:52a:c018:6cdf with SMTP id cm8-20020a056a00338800b0052ac0186cdfmr1305849pfb.55.1659061314580;
        Thu, 28 Jul 2022 19:21:54 -0700 (PDT)
Received: from [192.168.10.153] (203-7-124-83.dyn.iinet.net.au. [203.7.124.83])
        by smtp.gmail.com with ESMTPSA id s15-20020aa78bcf000000b0052bae7b2af8sm1437727pfd.201.2022.07.28.19.21.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 19:21:54 -0700 (PDT)
Message-ID: <300aa0fe-31c5-4ed2-d0a2-597c2c305f91@ozlabs.ru>
Date:   Fri, 29 Jul 2022 12:21:46 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:103.0) Gecko/20100101
 Thunderbird/103.0
Subject: Re: [PATCH kernel] powerpc/iommu: Add iommu_ops to report
 capabilities and allow blocking domains
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Rodel, Jorg" <jroedel@suse.de>, Joel Stanley <joel@jms.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Oliver O'Halloran <oohall@gmail.com>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
References: <20220707135552.3688927-1-aik@ozlabs.ru>
 <20220707151002.GB1705032@nvidia.com>
 <bb8f4c93-6cbc-0106-d4c1-1f3c0751fbba@ozlabs.ru>
 <bbe29694-66a3-275b-5a79-71237ad7388f@ozlabs.ru>
 <BN9PR11MB527690152FE449D26576D2FE8C829@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <BN9PR11MB527690152FE449D26576D2FE8C829@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 08/07/2022 17:32, Tian, Kevin wrote:
>> From: Alexey Kardashevskiy <aik@ozlabs.ru>
>> Sent: Friday, July 8, 2022 2:35 PM
>> On 7/8/22 15:00, Alexey Kardashevskiy wrote:
>>>
>>>
>>> On 7/8/22 01:10, Jason Gunthorpe wrote:
>>>> On Thu, Jul 07, 2022 at 11:55:52PM +1000, Alexey Kardashevskiy wrote:
>>>>> Historically PPC64 managed to avoid using iommu_ops. The VFIO driver
>>>>> uses a SPAPR TCE sub-driver and all iommu_ops uses were kept in
>>>>> the Type1 VFIO driver. Recent development though has added a
>> coherency
>>>>> capability check to the generic part of VFIO and essentially disabled
>>>>> VFIO on PPC64; the similar story about
>> iommu_group_dma_owner_claimed().
>>>>>
>>>>> This adds an iommu_ops stub which reports support for cache
>>>>> coherency. Because bus_set_iommu() triggers IOMMU probing of PCI
>>>>> devices,
>>>>> this provides minimum code for the probing to not crash.
> 
> stale comment since this patch doesn't use bus_set_iommu() now.
> 
>>>>> +
>>>>> +static int spapr_tce_iommu_attach_dev(struct iommu_domain *dom,
>>>>> +                      struct device *dev)
>>>>> +{
>>>>> +    return 0;
>>>>> +}
>>>>
>>>> It is important when this returns that the iommu translation is all
>>>> emptied. There should be no left over translations from the DMA API at
>>>> this point. I have no idea how power works in this regard, but it
>>>> should be explained why this is safe in a comment at a minimum.
>>>>
>>>   > It will turn into a security problem to allow kernel mappings to leak
>>>   > past this point.
>>>   >
>>>
>>> I've added for v2 checking for no valid mappings for a device (or, more
>>> precisely, in the associated iommu_group), this domain does not need
>>> checking, right?
>>
>>
>> Uff, not that simple. Looks like once a device is in a group, its
>> dma_ops is set to iommu_dma_ops and IOMMU code owns DMA. I guess
>> then
>> there is a way to set those to NULL or do something similar to let
>> dma_map_direct() from kernel/dma/mapping.c return "true", is not there?
> 
> dev->dma_ops is NULL as long as you don't handle DMA domain type
> here and don't call iommu_setup_dma_ops().
> 
> Given this only supports blocking domain then above should be irrelevant.
> 
>>
>> For now I'll add a comment in spapr_tce_iommu_attach_dev() that it is
>> fine to do nothing as tce_iommu_take_ownership() and
>> tce_iommu_take_ownership_ddw() take care of not having active DMA
>> mappings. Thanks,
>>
>>
>>>
>>> In general, is "domain" something from hardware or it is a software
>>> concept? Thanks,
>>>
> 
> 'domain' is a software concept to represent the hardware I/O page
> table. 


About this. If a platform has a concept of explicit DMA windows (2 or 
more), is it one domain with 2 windows or 2 domains with one window each?

If it is 2 windows, iommu_domain_ops misses windows manipulation 
callbacks (I vaguely remember it being there for embedded PPC64 but 
cannot find it quickly).

If it is 1 window per a domain, then can a device be attached to 2 
domains at least in theory (I suspect not)?

On server POWER CPUs, each DMA window is backed by an independent IOMMU 
page table. (reminder) A window is a bus address range where devices are 
allowed to DMA to/from ;)

Thanks,


> A blocking domain means all DMAs from a device attached to
> this domain are blocked/rejected (equivalent to an empty I/O page
> table), usually enforced in the .attach_dev() callback.
> 
> Yes, a comment for why having a NULL .attach_dev() is OK is welcomed.
> 
> Thanks
> Kevin

-- 
Alexey
