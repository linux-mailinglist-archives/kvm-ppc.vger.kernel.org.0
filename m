Return-Path: <kvm-ppc+bounces-78-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F65788D7E0
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 Mar 2024 08:50:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D43E1F29FDB
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 Mar 2024 07:50:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5276255765;
	Wed, 27 Mar 2024 07:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jj9ivhb3"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA2C548FB
	for <kvm-ppc@vger.kernel.org>; Wed, 27 Mar 2024 07:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711525544; cv=none; b=tQ5X9MujYWf9kjWP3cbUUha7HBGjPd07swWtUoFdCyypFk7k1D2u7WVL+oba6VJ8aTq0QQxKbzdIixCSWVLS7djpJGpnUksGRUFyvrJpQ+sSXPOWs8nh64ynuxNpD0a+Ch7j3/S+DAtgqOUdQDxNKMNDJc66Sy4hDXPWnmHgGGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711525544; c=relaxed/simple;
	bh=+h9b9dc1HQ8JjvLGaS6gVQiOAQDmPTooRsejGtjyC6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=culZR60OXZ4zdA3OyMlmf+Tua+wVtnLHxeze+P/y/SmqrmFHyq8qSJLTKE4uCXpsdYtkDZkeHIQfSprmmwvD9Hpc52v2n4jEFDCg0zvu0pAriLfGldTrjnj2OJWp3qAI5vVpuGvuHYlXiYnSE+MIzBZUBy4GvucYf4G7U9luZqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jj9ivhb3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711525541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FZMXX8B4WgiI8I0U0ZLUJTys0q6LBrTBUSIKNZ48Uk0=;
	b=Jj9ivhb38q0qzvK9y01htiTfCo7ZYsiI3aSvmucGsDUEbbR2OfW1QaucOJH5Mt9+wSHbs5
	LQyxQ0FgJc68TPFj/NOFHVDTGvk3LJG+t74kH2bNuPp+CunZqGoi1dywCiZg0nUnZS7URl
	vTx2RqJHimbagge/ooSjQqisqMTDnP4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-KZW_24iCMziGW_sm-egT0Q-1; Wed, 27 Mar 2024 03:45:39 -0400
X-MC-Unique: KZW_24iCMziGW_sm-egT0Q-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-56c0d3514baso1762521a12.0
        for <kvm-ppc@vger.kernel.org>; Wed, 27 Mar 2024 00:45:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711525538; x=1712130338;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FZMXX8B4WgiI8I0U0ZLUJTys0q6LBrTBUSIKNZ48Uk0=;
        b=OTOE3PSMeXh91Y519nIBPw8vNoAUeJtLyMwYZzMx+X/k3DUmJEyqbZmAF869HmhpAG
         k0kQSODmdtfX0uVEA44e8dCZo/Ue+Dmo4Jt8NAOuKvO9NZGSzUxarYErl5TSoXDs/6wL
         G6Q5HkPMl211fcDtY7YEQT6QlpggAkdO26XgIjUFXBmiV3RGcQ/QNSt0IvzN/GQ7NpJJ
         BfyZzu3G12tivrrrzfmR8g4ieiSR1rjmRwiwJP0qgwXNMmWTWG4zkFR0aTY5jR7Fdj0E
         epogGiL5ApDxi2FFsRHew+tHkqWa7MIiqQ6ss1BQ+Y7s9oFyMmmPRF4y132jI6NI/rKW
         bjag==
X-Forwarded-Encrypted: i=1; AJvYcCWUCii1UICwJgBfIoUfUyHajuCG4rV0V8/H0J+PszqwvOMO8MueGxhZ+WIGusO6D6AocAbArkfzw1KH/S73Go5cRiMDlNROJA==
X-Gm-Message-State: AOJu0YwYuPerg6i5mfd3TVgJv0BHT6sOqjGfQNNoXkYCbmhbeLKfAm3r
	GBJg0o651q866AgMds6rT1Ai5MphIMn4uVOz7EpUKDgEPRp/34M50Vlv2wcDJ/jOpR7RuIap0SI
	e2Pmuptsit0hxXavjuikKgrRDC37WpjWZrkeGJBsIayZa2PRAIJVTszM=
X-Received: by 2002:a50:9e89:0:b0:56b:b227:efc4 with SMTP id a9-20020a509e89000000b0056bb227efc4mr1123101edf.18.1711525538728;
        Wed, 27 Mar 2024 00:45:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqynRMBwvNKCqV8Z9T3nG3Q0+r4lT3eQp+QiP+8W3CV1ql7iUyheTLA+ExECEkwwF/bvGxiA==
X-Received: by 2002:a50:9e89:0:b0:56b:b227:efc4 with SMTP id a9-20020a509e89000000b0056bb227efc4mr1123088edf.18.1711525538347;
        Wed, 27 Mar 2024 00:45:38 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-177-37.web.vodafone.de. [109.43.177.37])
        by smtp.gmail.com with ESMTPSA id r1-20020aa7cb81000000b0056c052f9fafsm4130045edt.53.2024.03.27.00.45.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 00:45:38 -0700 (PDT)
Message-ID: <1a2c81ce-e876-4684-a1f7-f68cfc5ccdae@redhat.com>
Date: Wed, 27 Mar 2024 08:45:36 +0100
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] slof/fs/packages/disk-label.fs: improve checking for
 DOS boot partitions
To: Kautuk Consul <kconsul@linux.ibm.com>, aik@ozlabs.ru
Cc: slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
References: <20240327054127.633598-1-kconsul@linux.ibm.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240327054127.633598-1-kconsul@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/03/2024 06.41, Kautuk Consul wrote:
> While testing with a qcow2 with a DOS boot partition it was found that
> when we set the logical_block_size in the guest XML to >512 then the
> boot would fail in the following interminable loop:
> <SNIP>
> Trying to load:  from: /pci@800000020000000/scsi@3 ... virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> </SNIP>
> 
> Change the count-dos-logical-partitions Forth subroutine and the Forth
> subroutines calling count-dos-logical-partitions to check for this access
> beyond end of device error.
> 
> After making the above changes, it fails properly with the correct error
> message as follows:
> <SNIP>
> Trying to load:  from: /pci@800000020000000/scsi@3 ... virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> 
> E3404: Not a bootable device!
> 
> E3407: Load failed
> 
>    Type 'boot' and press return to continue booting the system.
>    Type 'reset-all' and press return to reboot the system.
> 
> Ready!
> 0 >
> </SNIP>
> 
> Signed-off-by: Kautuk Consul <kconsul@linux.ibm.com>
> ---
>   slof/fs/packages/disk-label.fs | 16 ++++++++++++----
>   1 file changed, 12 insertions(+), 4 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>


