Return-Path: <kvm-ppc+bounces-71-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 113F487E6FF
	for <lists+kvm-ppc@lfdr.de>; Mon, 18 Mar 2024 11:15:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 308A71C216B8
	for <lists+kvm-ppc@lfdr.de>; Mon, 18 Mar 2024 10:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACDA42D04C;
	Mon, 18 Mar 2024 10:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I0dQeNyB"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84163FB92
	for <kvm-ppc@vger.kernel.org>; Mon, 18 Mar 2024 10:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710756733; cv=none; b=q+bJjCA+yrDOmNJi4wG4XbU5dBZAMAhBso7vTfOAq7aUyYE0zbWRCswUmO+lrkhABfjiFM3EIsQjycctCS7wzFJT4vOgN6po/ZKWTOirtezNga1vwBQ4jlt8fCiQej1sm2/voLxMk1bsN8nPzjCFwcein0m4ZMnMrwSiONtTnn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710756733; c=relaxed/simple;
	bh=heOUeWUA0azoIbmaYodno6Vu8LZWdpMAFVxOaVT4gyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HFrsUqCGzdCZ7syLhW/f4mTBaGSNd8WkSPbZnR1GNytEvQl4Xong54G+xIZQYC4rnMUDl/X4ml9/G1PaScufvxAI7FMAq1NAh5t/T72C98nGC0kWhip6M43rutrumYjacO5n+6tEKZgQs47fX3/RwEZYQtpQCwfyBOe9SLyM4oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I0dQeNyB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710756730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=T3fHOxbhbtUaFpxOTOvKfKiI22peQ+xzpn2bUn9Yabs=;
	b=I0dQeNyBEexVcNsgUDAjhUl/tOpxkYuVGWRWDBWucobPWl6BK0P/hnPzW+D5Tb4QwkJtk6
	PSl5lEk42MuwuiMfjmhDhNDY7uW6pBUIIlLl80VgHI/VqwOmVeVf0A6hBVXc2qj6+Dhinf
	DWvzjH7sjejRLNAMsB4PPr8644nBSKk=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-AfopIpO8N6uDRa0NI-js4A-1; Mon, 18 Mar 2024 06:12:08 -0400
X-MC-Unique: AfopIpO8N6uDRa0NI-js4A-1
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-6dde168a7aeso3527868a34.1
        for <kvm-ppc@vger.kernel.org>; Mon, 18 Mar 2024 03:12:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710756728; x=1711361528;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T3fHOxbhbtUaFpxOTOvKfKiI22peQ+xzpn2bUn9Yabs=;
        b=I4ZSE8GYrCN5hET6hzIRt7Epra7K54oFS5z0EVCRzMS7VZUKDsQMJq1FUwnfxuSqxq
         0BzboFyP7FrUIG8BekffS94DqVCm7oInlaQnNq3JelqOr/sQC5NjxbcjQEZ6OIQBqxPp
         3piowiEmPUYMglal2LtHzoux9zG8kcTN3xZvODB2vacpUkX59HYzgCtN4jK31Aai2iLz
         ZvUkysMXNtUYT4HpfTUdcAYIrn2pMwy1FJAkNDRQwCbPyASq5SCzDX4VP1zuEfgArqoB
         YPA0yLolhVuUlIZ7lbrgmCkDdEjY9xhbykwDHFpJTC+SKXM52lgUBJJOPp5eNuXt7sk2
         jfig==
X-Forwarded-Encrypted: i=1; AJvYcCUfV2T9GSBKu5PjsvWcyqeDnncCNbhxIjAeiSbMAPvYdQB8qSjbXXoXylvS7IcYEOmTV/eGKszimGV+AJoZcN6Mr0MFxJX0/w==
X-Gm-Message-State: AOJu0Ywlg/7zINBTIlenvAvqO4xpFr4lVHsRg6IIvmxg9MCfbRHnPzBb
	MsTZqEtjLPZ3YkX+EHuU6x98IEiKgWibYYq8w7OPpQS6fGYhRGVLzq+Uu6S0ghX4khgBdEV4ERB
	MVykq05jfJRC88JdDg5HHzT00Z2WahNn1TlwLsMMpTshi45+m8LP2unA=
X-Received: by 2002:a9d:76c4:0:b0:6e6:6a62:9304 with SMTP id p4-20020a9d76c4000000b006e66a629304mr11246923otl.13.1710756727856;
        Mon, 18 Mar 2024 03:12:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXvIZiWrPnshixqsUNy0qeFiBcCPA23wIIhKIjG/iCul6yck9hf3vU0WiX9qV+HVF1wbDUxQ==
X-Received: by 2002:a9d:76c4:0:b0:6e6:6a62:9304 with SMTP id p4-20020a9d76c4000000b006e66a629304mr11246919otl.13.1710756727585;
        Mon, 18 Mar 2024 03:12:07 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-176-251.web.vodafone.de. [109.43.176.251])
        by smtp.gmail.com with ESMTPSA id jr11-20020a0562142a8b00b006960f65e08esm1756003qvb.132.2024.03.18.03.12.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Mar 2024 03:12:07 -0700 (PDT)
Message-ID: <645a1ae3-949a-4225-b6f6-81f782320a88@redhat.com>
Date: Mon, 18 Mar 2024 11:12:03 +0100
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slof/fs/packages/disk-label.fs: improve checking for DOS
 boot partitions
Content-Language: en-US
To: Kautuk Consul <kconsul@linux.vnet.ibm.com>, aik@ozlabs.ru
Cc: slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
References: <20240222061046.42572-1-kconsul@linux.vnet.ibm.com>
 <ZelgMYUM0CzMVjbE@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <ZffNo8fEywkKHQPA@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <ZffNo8fEywkKHQPA@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/03/2024 06.14, Kautuk Consul wrote:
> Hi,
>>
>> On 2024-02-22 01:10:46, Kautuk Consul wrote:
>>> While testing with a qcow2 with a DOS boot partition it was found that
>>> when we set the logical_block_size in the guest XML to >512 then the
>>> boot would fail
...
>>> diff --git a/slof/fs/packages/disk-label.fs b/slof/fs/packages/disk-label.fs
>>> index 661c6b0..e680847 100644
>>> --- a/slof/fs/packages/disk-label.fs
>>> +++ b/slof/fs/packages/disk-label.fs
>>> @@ -139,6 +139,13 @@ CONSTANT /gpt-part-entry
>>>      block block-size read drop    \ read sector
>>>   ;
>>>
>>> +\ read sector to array "block" and return actual bytes read
>>> +: read-sector-ret ( sector-number -- actual)

Please add a space between "actual" and ")". I'd maybe also rather say 
"actual-bytes" so that nobody expects "actual-sectors" here.

>>> +   \ block-size is 0x200 on disks, 0x800 on cdrom drives
>>> +   block-size * 0 seek drop      \ seek to sector
>>> +   block block-size read    \ read sector
>>> +;

Could we please avoid duplicating code here? "read-sector" could now simply 
be implemented via read-sector-ret instead:

\ read sector to array "block" and return actual bytes read
: read-sector-ret ( sector-number -- actual-bytes )
     \ block-size is 0x200 on disks, 0x800 on cdrom drives
     block-size * 0 seek drop    \ seek to sector
     block block-size read       \ read sector
;

: read-sector ( sector-number -- )
     read-sector-ret drop
;

>>>   : (.part-entry) ( part-entry )
>>>      cr ." part-entry>active:        " dup part-entry>active c@ .d
>>>      cr ." part-entry>start-head:    " dup part-entry>start-head c@ .d
>>> @@ -204,7 +211,8 @@ CONSTANT /gpt-part-entry
>>>            part-entry>sector-offset l@-le    ( current sector )
>>>            dup to part-start to lpart-start  ( current )
>>>            BEGIN
>>> -            part-start read-sector          \ read EBR
>>> +            part-start read-sector-ret          \ read EBR
>>> +            block-size < IF UNLOOP 0 EXIT THEN
>>>               1 partition>start-sector IF
>>>                  \ ." Logical Partition found at " part-start .d cr
>>>                  1+
>>> @@ -279,6 +287,7 @@ CONSTANT /gpt-part-entry
>>>      THEN
>>>
>>>      count-dos-logical-partitions TO dos-logical-partitions
>>> +   dos-logical-partitions 0= IF false EXIT THEN
>>>
>>>      debug-disk-label? IF
>>>         ." Found " dos-logical-partitions .d ." logical partitions" cr
>>> @@ -352,6 +361,7 @@ CONSTANT /gpt-part-entry
>>>      no-mbr? IF drop FALSE EXIT THEN  \ read MBR and check for DOS disk-label magic
>>>
>>>      count-dos-logical-partitions TO dos-logical-partitions
>>> +   dos-logical-partitions 0= IF 0 EXIT THEN
>>>
>>>      debug-disk-label? IF
>>>         ." Found " dos-logical-partitions .d ." logical partitions" cr
>>> -- 
>>> 2.31.1
>>>
> 
> So how does the patch look ? Any comments from anyone ?

Sorry, your original patch somehow didn't make it to my Inbox (though it's 
visible on http://patchwork.ozlabs.org/project/slof/list/ so the problem is 
certainly on my receiving side), so I just learnt about this patch today.

Anyway, apart from the code duplication, it looks fine to me, so if you 
could fix that in a v2, that would be great!

  Thomas


