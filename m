Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B836441CF
	for <lists+kvm-ppc@lfdr.de>; Tue,  6 Dec 2022 12:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbiLFLFf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 6 Dec 2022 06:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiLFLFd (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 6 Dec 2022 06:05:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CD1C56
        for <kvm-ppc@vger.kernel.org>; Tue,  6 Dec 2022 03:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670324681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zG8rwTMFkKIJu2ONvMMrGsUIc0TjTg+lML/JcqqEhgA=;
        b=A++iYMFKMgyQLAdypBhEuhH5ydsnNjQ66+rTO0LHnzDZEhCgaD6/VZLeKfAU3Z6fBljZDS
        /PsF0/oEJdVcnC6I8y8iCu7nxacLFyOtlmdrcxfWX0TmNwL2uv1wb8IK2LY7+wFNwE6luz
        z5bpAWSA9MVJEErpwKBMXFYNxGUgiWU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-669-eD2pXk98Ny6ASCYAf949ZA-1; Tue, 06 Dec 2022 06:04:40 -0500
X-MC-Unique: eD2pXk98Ny6ASCYAf949ZA-1
Received: by mail-wm1-f69.google.com with SMTP id o5-20020a05600c510500b003cfca1a327fso8275388wms.8
        for <kvm-ppc@vger.kernel.org>; Tue, 06 Dec 2022 03:04:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zG8rwTMFkKIJu2ONvMMrGsUIc0TjTg+lML/JcqqEhgA=;
        b=jN4QcaYGrK8LSqnKjQwaik3HyzR2hgAqFDuoiBPwW21EoPirI8i9i7O/EJtCYogow7
         jxfVvQkxKhudQCki4xsSli8oLdHh4taUJ5L3bpWTxMqTPtsgC0SHIJDjeejebYNjwkCB
         coqxW3nRHn4EG8qFz0VBvWA+sZZMbZfdo3V4a40ulxOL/1Xj8jMzyRR7LG9kPDQjP4dN
         5GVfILc1LAG9G8knHWIBPNDCJow52EQ6eNvO+XRqraSsisJT0oCn3YJMMOo5BFqGOEsh
         EGlMDcWR7dV0ePe+5xXyMp7tmxNAfu1T+5CoVvyOKLm8CeTJAhOy19p4MkrituYKmvAb
         vm/Q==
X-Gm-Message-State: ANoB5pno47myBEK+VMojazo+eDgAE5CltBU8f5LYd9Pmqn3nwLay+odC
        sCK9G0coMyHydz6+DzQjxYbVq7YTD6G7xevetja/JXkYSk1zG6tcB6U+6WSFla1t02Q+xljW23w
        a1fxN/UzZP+1lYblqyA==
X-Received: by 2002:a5d:5251:0:b0:242:39bc:497 with SMTP id k17-20020a5d5251000000b0024239bc0497mr13701313wrc.411.1670324679248;
        Tue, 06 Dec 2022 03:04:39 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4IMbjsHwE5jZiaGMXUE2Yvzrqj8yUx6t5yGSLu+C5wtNqJK1Stm3HKR2rjpXlF7VjK2iQfYA==
X-Received: by 2002:a5d:5251:0:b0:242:39bc:497 with SMTP id k17-20020a5d5251000000b0024239bc0497mr13701297wrc.411.1670324679000;
        Tue, 06 Dec 2022 03:04:39 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-178-155.web.vodafone.de. [109.43.178.155])
        by smtp.gmail.com with ESMTPSA id n186-20020a1ca4c3000000b003d1cf67460esm5847434wme.40.2022.12.06.03.04.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 03:04:38 -0800 (PST)
Message-ID: <4e6c86cb-cd8e-1ac1-7e0f-463ee9b5a882@redhat.com>
Date:   Tue, 6 Dec 2022 12:04:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH] powerpc: Fix running the kvm-unit-tests
 with recent versions of QEMU
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>
References: <20221206101455.145258-1-thuth@redhat.com>
 <e857891c-e41a-c953-fb21-730fa74ea7d1@kaod.org>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <e857891c-e41a-c953-fb21-730fa74ea7d1@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 06/12/2022 11.40, Cédric Le Goater wrote:
> On 12/6/22 11:14, Thomas Huth wrote:
>> Starting with version 7.0, QEMU starts the pseries guests in 32-bit mode
>> instead of 64-bit (see QEMU commit 6e3f09c28a - "spapr: Force 32bit when
>> resetting a core"). This causes our test_64bit() in powerpc/emulator.c
>> to fail. Let's switch to 64-bit in our startup code instead to fix the
>> issue.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   powerpc/cstart64.S | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
>> index 972851f9..206c518f 100644
>> --- a/powerpc/cstart64.S
>> +++ b/powerpc/cstart64.S
>> @@ -23,6 +23,12 @@
>>   .globl start
>>   start:
>>       FIXUP_ENDIAN
>> +    /* Switch to 64-bit mode */
>> +    mfmsr    r1
>> +    li    r2,1
>> +    sldi    r2,r2,63
>> +    or    r1,r1,r2
>> +    mtmsrd    r1
>>       /*
>>        * We were loaded at QEMU's kernel load address, but we're not
>>        * allowed to link there due to how QEMU deals with linker VMAs,
> 
> You could add this define in lib/powerpc/asm/ppc_asm.h  :
> 
> #define MSR_SF    0x8000000000000000ul
> 
> and possibly use the LOAD_REG_IMMEDIATE macro to set the MSR.

Using LOAD_REG_IMMEDIATE would add quite a bit of additional instructions 
here, so not sure whether I like it ... but I think I could add a proper 
#define for 63 at least.

  Thomas

