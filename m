Return-Path: <kvm-ppc+bounces-74-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ABB6288C584
	for <lists+kvm-ppc@lfdr.de>; Tue, 26 Mar 2024 15:45:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C60D304092
	for <lists+kvm-ppc@lfdr.de>; Tue, 26 Mar 2024 14:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 911394E1DB;
	Tue, 26 Mar 2024 14:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AcVsEW/9"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3B9ED9
	for <kvm-ppc@vger.kernel.org>; Tue, 26 Mar 2024 14:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711464355; cv=none; b=dSdw5YpXpUv0PXAkUF75A+zGrz73eBdUu9au5Mfj1ENDIPY5sPuvzbh+m+JwlUbAFwhgDw5qgxsrH+Wyn6m9M8lGddUrti7/787VaPnZF7x+afVNX/h03X/IMu0+vrlyIErhEIWqXiDJu8Usj1NFrUKQ/xQe+OBg5KaL74Yy1TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711464355; c=relaxed/simple;
	bh=pa//blhMHMdJEiN1KbEeumoJUt1CuBE1Fo2JX9SOHG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y0PY2NNlJ45U0PKusk5bzA6QtIHQsJZWUJaq6lTpCNznAHu1FOashElkCxt4RRsY2Di0CKgkxf7CrFlcVDVZJf+qmoRt3Zi1zcmc9JmlFmMXGP4Mr5hcnIAMkJRyWyAJJBPGLsERTUTVoD4WfZ5fkQz5/DVAIaPiUVh3vved6bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AcVsEW/9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711464352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BYs9VrOZw/WC47q8J9qJUsBs5532yWXg0XKd1M6jSfo=;
	b=AcVsEW/92wm//B6hb654azyEMtE63vskFSlooGMHbpzLnrflyFiudq70iZBPN6OkPt6RSP
	maFh9C+BEb9l0T8n7HJIe/qguRDOeVOQyGgsX1bFcm/osKgLYsUupcRPXFp489Fr3Qfvjc
	5NEy4jYzIxH30cINXXYCQuFT0Oshgkc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-kBT-mokrOR2UcUp8oe-Geg-1; Tue, 26 Mar 2024 10:45:51 -0400
X-MC-Unique: kBT-mokrOR2UcUp8oe-Geg-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-78a69ec1498so34688585a.1
        for <kvm-ppc@vger.kernel.org>; Tue, 26 Mar 2024 07:45:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711464351; x=1712069151;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BYs9VrOZw/WC47q8J9qJUsBs5532yWXg0XKd1M6jSfo=;
        b=Qew0EIkezRnPXqQFMq3dw8L70fIY+W5aXG+G65WA6f9RNu+zIMYV+iGTHPP787wx4U
         6mFjb2i/o6A9OwwziXsTIutZ/KrSlgz9TWdmYMCbrHNb6aNy7H5vSdbwzvA4uXSny8K9
         b94ulmyoR2qowjV/y0gwYMyMpKV1uy+1bdFYGKTMT54xQ0Hx8lE9Rs6u9fC0gA0UMcXD
         mppqGE8UE2QGt0IP/fSNFMZEA+5NrsX9+/cShf/GxIEPXHpiN8yNpzj7pWPBDqzJFS11
         bxAJpFU/ZiKNdvFOlByD6mPCXS1wo/Lns08A/+NoTLvEEcnrsFz03lgaxtikR/kpU70r
         wOUw==
X-Forwarded-Encrypted: i=1; AJvYcCVbZunB7aSdrClm5b8EnUT21Lp/V0XzktgFmCgb8bA2q8C5Cv9CuDrr+ZkuvDpigU9FNlzX9T17q8WVVbztfMKc7ah7xTgVOg==
X-Gm-Message-State: AOJu0Yx5aJcweTLUrqInAkagx5O1hHSmMY39odsEpB/uRX5/0jLRe9Px
	Ij1PJbiTlYdzIVmc7xvl4fOyRZNwerc5TW+1mzWGbRdyg8x2JE6Cxf2xW8tozl0AQdZxyxfryzk
	+2dgVMmx77OAOuUS13w8H6T96aSj3nH2dL5FmKlPNcNNUrY9X7eyAtuw=
X-Received: by 2002:a05:620a:3956:b0:789:f16f:f93c with SMTP id qs22-20020a05620a395600b00789f16ff93cmr2324886qkn.32.1711464350839;
        Tue, 26 Mar 2024 07:45:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxWp6aU046f+ImlPHyHTy2ICBR490Oc3jiPDWMU/A7A24GYx7I9aMVlbvKcD9k0XM89//GSw==
X-Received: by 2002:a05:620a:3956:b0:789:f16f:f93c with SMTP id qs22-20020a05620a395600b00789f16ff93cmr2324866qkn.32.1711464350530;
        Tue, 26 Mar 2024 07:45:50 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-177-37.web.vodafone.de. [109.43.177.37])
        by smtp.gmail.com with ESMTPSA id m15-20020ae9e70f000000b00789f5a04b3esm3028644qka.58.2024.03.26.07.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Mar 2024 07:45:50 -0700 (PDT)
Message-ID: <116481b9-7268-4a62-a3ac-576ffb538e1d@redhat.com>
Date: Tue, 26 Mar 2024 15:45:46 +0100
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [SLOF] [PATCH v2] slof/fs/packages/disk-label.fs: improve
 checking for DOS boot partitions
To: Kautuk Consul <kconsul@linux.ibm.com>, aik@ozlabs.ru
Cc: slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
References: <20240318103003.484602-1-kconsul@linux.vnet.ibm.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240318103003.484602-1-kconsul@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/03/2024 11.30, Kautuk Consul wrote:
> While testing with a qcow2 with a DOS boot partition it was found that
> when we set the logical_block_size in the guest XML to >512 then the
> boot would fail 
...
> diff --git a/slof/fs/packages/disk-label.fs b/slof/fs/packages/disk-label.fs
> index 661c6b0..2630701 100644
> --- a/slof/fs/packages/disk-label.fs
> +++ b/slof/fs/packages/disk-label.fs
> @@ -132,11 +132,16 @@ CONSTANT /gpt-part-entry
>      debug-disk-label? IF dup ." actual=" .d cr THEN
>   ;
>   
> -\ read sector to array "block"
> -: read-sector ( sector-number -- )
> +\ read sector to array "block" and return actual bytes read
> +: read-sector-ret ( sector-number -- actual-bytes )
>      \ block-size is 0x200 on disks, 0x800 on cdrom drives
>      block-size * 0 seek drop      \ seek to sector
> -   block block-size read drop    \ read sector
> +   block block-size read    \ read sector
> +;
> +
> +\ read sector to array "block"
> +: read-sector ( sector-number -- )
> +   read-sector-ret drop
>   ;
>   
>   : (.part-entry) ( part-entry )
> @@ -204,7 +209,8 @@ CONSTANT /gpt-part-entry
>            part-entry>sector-offset l@-le    ( current sector )
>            dup to part-start to lpart-start  ( current )

I just noticed that according to the stack comment above, there is a 
"current" item on the stack...

>            BEGIN
> -            part-start read-sector          \ read EBR
> +            part-start read-sector-ret          \ read EBR
> +            block-size < IF UNLOOP 0 EXIT THEN

... which doesn't get dropped here before the EXIT ? Is the stack still 
right after this function exited early?

>               1 partition>start-sector IF
>                  \ ." Logical Partition found at " part-start .d cr
>                  1+
> @@ -279,6 +285,7 @@ CONSTANT /gpt-part-entry
>      THEN
>   
>      count-dos-logical-partitions TO dos-logical-partitions
> +   dos-logical-partitions 0= IF false EXIT THEN
>   
>      debug-disk-label? IF
>         ." Found " dos-logical-partitions .d ." logical partitions" cr
> @@ -352,6 +359,7 @@ CONSTANT /gpt-part-entry
>      no-mbr? IF drop FALSE EXIT THEN  \ read MBR and check for DOS disk-label magic
>   
>      count-dos-logical-partitions TO dos-logical-partitions
> +   dos-logical-partitions 0= IF 0 EXIT THEN

Similar question here, what about the "addr" stack item? Shouldn't it be 
dropped first?

  Thomas


PS: I'm still having trouble receiving your mail, I just discovered v2 on 
patchwork and downloaded it from there...


