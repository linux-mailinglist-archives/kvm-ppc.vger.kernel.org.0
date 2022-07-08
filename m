Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B170F56BA51
	for <lists+kvm-ppc@lfdr.de>; Fri,  8 Jul 2022 15:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbiGHNIN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 8 Jul 2022 09:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbiGHNIM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 8 Jul 2022 09:08:12 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE849FC3
        for <kvm-ppc@vger.kernel.org>; Fri,  8 Jul 2022 06:08:10 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id fz10so11901675pjb.2
        for <kvm-ppc@vger.kernel.org>; Fri, 08 Jul 2022 06:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YX0GXIRGwrdV+uldKViTwGHPwQS8yZ0tHe4j59MVvtQ=;
        b=DEY/pPyi+VWfsqX8uOHchEyZqQFLDtLlgTSiONJuZaYtrzz57fiBLgg2Z4yskRD6h0
         pYWaY1twEgGSx+5C5E56IGfsebWU7wpOmLQ9C6T7q/W+EYj7KIHDewAaUS0gifxCQvxc
         Y4UhyYhWR7gOz4cQHI5iBCcLcidGpsnWvEm56UHEYBAegmcg5xcbxTlNCGfNtdSkNX2a
         x1YADMkRdHWk4zOGnZBzFyaPKEGgNTPGiT1zE7EwdCvgAPeOEIyi9xvJqGH3p1JuUcO1
         nRzzwe366RKB+wQkYWBDQrZWFr0LtZGd/IgHyDfLiV7cEsfJ/zSWZW6lW0e7hlccWtFu
         PuDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YX0GXIRGwrdV+uldKViTwGHPwQS8yZ0tHe4j59MVvtQ=;
        b=YFsj3VWbSIyilpwQaFB5xP80OUgh62H2vI2U4ONl2LAwqioypC1Zf3DL/PcxsmnwV4
         1I8zADJ4yeYsgazFu63/T83PiYIY+Ai5rGjbvOZuWSgOYE7fLZRKCZWcBkN/sYkaAuTQ
         Rj4teVhRdYAjoIjPKhVKxlJjFYli/wRQM3uWY0aGCEdEAXE8BF3KQ9JY8buuFM2oXHgX
         WmJces+jKQEcEq5e0wmgUN4Ee/izNWNXrUf4NU6rOHp6HNaB3+N5dXLFZkd+KyhB9hRL
         8TTwmmDoDqivgh1AIyNrY8t2FLFt4v63Klzu0E/WP9ePhV41SzHRwWiB1Dmaz9iP8C3Z
         HJUQ==
X-Gm-Message-State: AJIora8ETMiZ3Ee0BRjkOGWslKZzZvhs5V89zLYHdxsYyc/iKdhqyjWK
        WKQ2OIP9IIUa9VeTEMydnRr/Tw==
X-Google-Smtp-Source: AGRyM1tIuwtgC87J64k+xqlvM6tTmdIe635uk72+ahanJtLXUEnXZxxc4ICJdBfra3AtS9Fz4aG8Pg==
X-Received: by 2002:a17:902:ba8a:b0:16b:988f:9279 with SMTP id k10-20020a170902ba8a00b0016b988f9279mr3681225pls.114.1657285690543;
        Fri, 08 Jul 2022 06:08:10 -0700 (PDT)
Received: from [192.168.10.153] (203-7-124-83.dyn.iinet.net.au. [203.7.124.83])
        by smtp.gmail.com with ESMTPSA id y62-20020a626441000000b0050dc76281d3sm2755672pfb.173.2022.07.08.06.08.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 06:08:09 -0700 (PDT)
Message-ID: <e24d91fb-3da9-d60a-3792-bca0fe550cc7@ozlabs.ru>
Date:   Fri, 8 Jul 2022 23:10:07 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH kernel] powerpc/iommu: Add iommu_ops to report
 capabilities and allow blocking domains
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linuxppc-dev@lists.ozlabs.org, Robin Murphy <robin.murphy@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Joerg Roedel <jroedel@suse.de>, Joel Stanley <joel@jms.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Oliver O'Halloran <oohall@gmail.com>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
References: <20220707135552.3688927-1-aik@ozlabs.ru>
 <20220707151002.GB1705032@nvidia.com>
 <bb8f4c93-6cbc-0106-d4c1-1f3c0751fbba@ozlabs.ru>
 <bbe29694-66a3-275b-5a79-71237ad7388f@ozlabs.ru>
 <20220708115522.GD1705032@nvidia.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20220708115522.GD1705032@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 08/07/2022 21:55, Jason Gunthorpe wrote:
> On Fri, Jul 08, 2022 at 04:34:55PM +1000, Alexey Kardashevskiy wrote:
> 
>> For now I'll add a comment in spapr_tce_iommu_attach_dev() that it is fine
>> to do nothing as tce_iommu_take_ownership() and
>> tce_iommu_take_ownership_ddw() take care of not having active DMA mappings.
> 
> That will still cause a security problem because
> tce_iommu_take_ownership()/etc are called too late. This is the moment
> in the flow when the ownershift must change away from the DMA API that
> power implements and to VFIO, not later.

It is getting better and better :)

On POWERNV, at the boot time the platforms sets up PHBs, enables bypass, 
creates groups and attaches devices. As for now attaching devices to the 
default domain (which is BLOCKED) fails the not-being-use check as 
enabled bypass means "everything is mapped for DMA". So at this point 
the default domain has to be IOMMU_DOMAIN_IDENTITY or 
IOMMU_DOMAIN_UNMANAGED so later on VFIO can move devices to 
IOMMU_DOMAIN_BLOCKED. Am I missing something?


> 
> Jason

-- 
Alexey
