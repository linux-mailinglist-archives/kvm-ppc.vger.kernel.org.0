Return-Path: <kvm-ppc+bounces-53-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8A1385F3DC
	for <lists+kvm-ppc@lfdr.de>; Thu, 22 Feb 2024 10:04:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 21F38B25AE4
	for <lists+kvm-ppc@lfdr.de>; Thu, 22 Feb 2024 09:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAFA7376F9;
	Thu, 22 Feb 2024 09:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Er5L3GZA"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF583717A
	for <kvm-ppc@vger.kernel.org>; Thu, 22 Feb 2024 09:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708592662; cv=none; b=eC0L99h9AIGXdVEg7n1+kwFllGfZ9Y8h94+vWofp6Oem+k+zWVCkQY00GmX+ZaRFLPDU/nMzvwWmdFu2B3Er6NU3iUT9VTKsMT/GnvA/pxIwXRXn+5/Y5ZcQarAmG24WMt4C1oeYgAXn+XE6VPxzcDnM9dHixEyh1o1JvOiD7Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708592662; c=relaxed/simple;
	bh=V+KUhcV5pV4loLK3aMLpldKcA0lx9BpLBpSVCdgNspQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kbGlEBHiB6Wkf0taxBBu3muDmemGdLsPRIYtdu0d7LvDCL4dZbGETXVndw/wY6b21mJsQBhrswkfQpYLCpgIB3KihEOwoNo/PkpA0oUDclcUZkov4JJ1JBSEbl5y9pAnqyNOJXo3f6/EEHvWJFiznRk+Way2E83lXVBM5BT+Gpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Er5L3GZA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708592659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DH8CDYxrsUQKLgYF9f34RbULBzsINeT617YZ/t1ukes=;
	b=Er5L3GZAfQsoNbyKn9ycaHoFCpD4FAEg3T7p8NFMIaZk6/pSZNZ2ZwXtUOQlpW2sC6p0g2
	7mdoj0cIW3BhEnq4gbv4kMUl2PPc+69BPkHy35Jdq57ftgN/NUphqpvD93MJQ4Muw5Xjtc
	AWZL9CMP99I6pCJdF+yJut0lL7s9oCQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-IiK8ibAuMtaYN_EDLlmhdg-1; Thu, 22 Feb 2024 04:04:17 -0500
X-MC-Unique: IiK8ibAuMtaYN_EDLlmhdg-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a3ee38c40baso210580266b.0
        for <kvm-ppc@vger.kernel.org>; Thu, 22 Feb 2024 01:04:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708592656; x=1709197456;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DH8CDYxrsUQKLgYF9f34RbULBzsINeT617YZ/t1ukes=;
        b=LGFNTf2jl1Z9CIpRxZUho/yi8Lpiv/gBecLEDk4d1J6iciiEPQ6KIODsFYJIbkrd4u
         xTgUCnYIY3cHMPiphKUzcGCCe07J9nAhf2Iq0PTigA2byojtAhUxhbad7di5pj/UeFQp
         dv82GFyEYNvTzZPyhtkpHgbGnnXMwqlOHMip4ZgxlgNrv74MjSL6yPe58irxVArCHoOc
         eb7MsgPK1s5e/yFOiMBaSCfArjmoTG764x9Pfhjw7Nxvmt+nxAgfHR4jwDvACnXJ2l8+
         fGqy7qfBXUDfxCxFg6uFSbMg/yt8SE/IXpkMeVzf61casg6nMcWtR7bdYDrHk6Q5ct0H
         t3/g==
X-Forwarded-Encrypted: i=1; AJvYcCW/PiZg0/Sil6iwmOkjJmLqOjMLP/Pk+DBqlE3dKGhFBBzgcsS+DWLTa3g9M0DUpVM9XQdrmqyy9hGomXzzHEHIIQAhlexKcQ==
X-Gm-Message-State: AOJu0YyrcY2bJEBdUp9SXXUpAoJrBUbvFS++5sSOKwu16puHebmYWzkX
	Mg1Z7l0RKYWeyug/KRC4eBJFWGR/gi36bmZKbYSHlhEmTsVQI5zvLG8zur7TkyL4R6bDvYD8PLA
	94pFNBb9SPBpVBeYdfOtRuRMbCwJ6dNOHEOGzG6zslKwqbmPadORqA1M=
X-Received: by 2002:a17:906:7c49:b0:a3f:70bc:bfe4 with SMTP id g9-20020a1709067c4900b00a3f70bcbfe4mr1293516ejp.31.1708592656329;
        Thu, 22 Feb 2024 01:04:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGin2FPt1S2g8Klyq0lqt8+EG4nx2tPRcoJ7+bquXY9KpcHOalq2Yz+RyLVFex1F7VM+wXhAA==
X-Received: by 2002:a17:906:7c49:b0:a3f:70bc:bfe4 with SMTP id g9-20020a1709067c4900b00a3f70bcbfe4mr1293505ejp.31.1708592655995;
        Thu, 22 Feb 2024 01:04:15 -0800 (PST)
Received: from [192.168.52.107] ([37.84.174.18])
        by smtp.gmail.com with ESMTPSA id s8-20020a170906168800b00a3e7a2d9ac4sm4258918ejd.6.2024.02.22.01.04.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Feb 2024 01:04:15 -0800 (PST)
Message-ID: <278a0e1e-b257-47ef-a908-801b9a223080@redhat.com>
Date: Thu, 22 Feb 2024 10:04:14 +0100
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] slof/engine.in: refine +COMP and -COMP by not using
 COMPILE
Content-Language: en-US
To: Kautuk Consul <kconsul@linux.vnet.ibm.com>,
 Segher Boessenkool <segher@kernel.crashing.org>, aik@ozlabs.ru,
 groug@kaod.org
Cc: slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
References: <20240202051548.877087-1-kconsul@linux.vnet.ibm.com>
 <Zdb56vX+ZpApmsqK@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <Zdb56vX+ZpApmsqK@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/02/2024 08.38, Kautuk Consul wrote:
> Hi Segher/Thomas,
> 
> On 2024-02-02 00:15:48, Kautuk Consul wrote:
>> Use the standard "DOTICK <word> COMPILE," mechanism in +COMP and -COMP
>> as is being used by the rest of the compiler.
>> Also use "SEMICOLON" instead of "EXIT" to compile into HERE in -COMP
>> as that is more informative as it mirrors the way the col() macro defines
>> a colon definition.
>>
>> Signed-off-by: Kautuk Consul <kconsul@linux.vnet.ibm.com>
>> ---
>>   slof/engine.in | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/slof/engine.in b/slof/engine.in
>> index 59e82f1..fa4d82e 100644
>> --- a/slof/engine.in
>> +++ b/slof/engine.in
>> @@ -422,8 +422,8 @@ imm(.( LIT(')') PARSE TYPE)
>>   col(COMPILE R> CELL+ DUP @ COMPILE, >R)
>>
>>   var(THERE 0)
>> -col(+COMP STATE @ 1 STATE +! 0BRANCH(1) EXIT HERE THERE ! COMP-BUFFER DOTO HERE COMPILE DOCOL)
>> -col(-COMP -1 STATE +! STATE @ 0BRANCH(1) EXIT COMPILE EXIT THERE @ DOTO HERE COMP-BUFFER EXECUTE)
>> +col(+COMP STATE @ 1 STATE +! 0BRANCH(1) EXIT HERE THERE ! COMP-BUFFER DOTO HERE DOTICK DOCOL COMPILE,)
>> +col(-COMP -1 STATE +! STATE @ 0BRANCH(1) EXIT DOTICK SEMICOLON COMPILE, THERE @ DOTO HERE COMP-BUFFER EXECUTE)
>>
> Did you get time to review this simple patch ?
> Is there something wrong in it or the description ?

  Hi Kautuk,

could you maybe do some performance checks to see whether this make a 
difference (e.g. by running the command in a tight loop many times)?
You can use "tb@" to get the current value of the timebase counter, so 
reading that before and after the loop should provide you with a way of 
measuring the required time.

  Thomas



