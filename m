Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDCBD0D69
	for <lists+kvm-ppc@lfdr.de>; Wed,  9 Oct 2019 13:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730398AbfJILMP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 9 Oct 2019 07:12:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34792 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbfJILMP (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 9 Oct 2019 07:12:15 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7E1F92A09A1
        for <kvm-ppc@vger.kernel.org>; Wed,  9 Oct 2019 11:12:14 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id m14so946704wru.17
        for <kvm-ppc@vger.kernel.org>; Wed, 09 Oct 2019 04:12:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X3f2+iJt/kBOoQ/oJmoBrarzOZ7jjd89Vg2qgN2ogok=;
        b=GRo26W2ZJI8Dp8OEcor+w/ky/0Gj+aYGDgcOi5YhPNywiivIGrnIik3rRxHjmhzU1r
         g7+WRNRqOqK0UqFGuEvfhq76oJqg3ZMS7CVaz472qrzYfzvpfwzpwESdUNzBABKponR+
         NozC6DjNXWtbRwffHTSQrJ11g4RvscPWCqE7HocaVhDBGG+m0djblFBgM8mMPSEUdLHZ
         flfRJslt2EF6kSbNc5Y/qTIkqf3vqRilu6eDIpB6spwthHvlk6DrY0V1mzyLozs68wOP
         I9Z6TwFt+AtvJdlyXYxLGEQby/R95rToOdjJ4ONI+s8PH70xNWC3OMPRwrZUTQjxCaTe
         7hQQ==
X-Gm-Message-State: APjAAAUbM58IXE0zxWXtM79mFIl9fPbxGlsb/It5OlpLDEBlTO30xIDb
        ty0u2zQIWzrXTODC4EFKC5Cwjqfng1tOvAKLEykeXr8Nhzs/XB1aFre1bLY0A2XLG7fwJhzH+JU
        3GvU8x03CqPpEZqvNdA==
X-Received: by 2002:adf:a50b:: with SMTP id i11mr2570511wrb.308.1570619533168;
        Wed, 09 Oct 2019 04:12:13 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzyO89gJwaKwMu2RpHe0Krai3w8QzU0jhU+LRWK6y5nt/hHA3tMoL9yOqLtFkC4R3hKCKZOmg==
X-Received: by 2002:adf:a50b:: with SMTP id i11mr2570491wrb.308.1570619532858;
        Wed, 09 Oct 2019 04:12:12 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id j1sm4371734wrg.24.2019.10.09.04.12.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 04:12:12 -0700 (PDT)
Subject: Re: [PATCH] powerpc: Fix up RTAS invocation for new qemu versions
To:     Thomas Huth <thuth@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>, lvivier@redhat.com
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, rkrcmar@redhat.com
References: <20191004103844.32590-1-david@gibson.dropbear.id.au>
 <07997795-3b64-5c85-e8a1-e9d81e57784e@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <db2c6aa6-4853-d2b4-3ee4-8603d19e4018@redhat.com>
Date:   Wed, 9 Oct 2019 13:12:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <07997795-3b64-5c85-e8a1-e9d81e57784e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 09/10/19 12:35, Thomas Huth wrote:
> On 04/10/2019 12.38, David Gibson wrote:
>> In order to call RTAS functions on powerpc kvm-unit-tests relies on the
>> RTAS blob supplied by qemu.  But new versions of qemu don't supply an RTAS
>> blob: since the normal way for guests to get RTAS is to call the guest
>> firmware's instantiate-rtas function, we now rely on that guest firmware
>> to provide the RTAS code itself.
>>
>> But qemu-kvm-tests bypasses the usual guest firmware to just run itself,
> 
> s/qemu-kvm-tests/kvm-unit-tests/
> 
>> so we can't get the rtas blob from SLOF.
>>
>> But.. in fact the RTAS blob under qemu is a bit of a sham anyway - it's
>> a tiny wrapper that forwards the RTAS call to a hypercall.  So, we can
>> just invoke that hypercall directly.
>>
>> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
>> ---
>>  lib/powerpc/asm/hcall.h |  3 +++
>>  lib/powerpc/rtas.c      |  6 +++---
>>  powerpc/cstart64.S      | 20 ++++++++++++++++----
>>  3 files changed, 22 insertions(+), 7 deletions(-)
>>
>> So.. "new versions of qemu" in this case means ones that incorporate
>> the pull request I just sent today.
>>
>> diff --git a/lib/powerpc/asm/hcall.h b/lib/powerpc/asm/hcall.h
>> index a8bd7e3..1173fea 100644
>> --- a/lib/powerpc/asm/hcall.h
>> +++ b/lib/powerpc/asm/hcall.h
>> @@ -24,6 +24,9 @@
>>  #define H_RANDOM		0x300
>>  #define H_SET_MODE		0x31C
>>  
>> +#define KVMPPC_HCALL_BASE	0xf000
>> +#define KVMPPC_H_RTAS		(KVMPPC_HCALL_BASE + 0x0)
>> +
>>  #ifndef __ASSEMBLY__
>>  /*
>>   * hcall_have_broken_sc1 checks if we're on a host with a broken sc1.
>> diff --git a/lib/powerpc/rtas.c b/lib/powerpc/rtas.c
>> index 2e7e0da..41c0a24 100644
>> --- a/lib/powerpc/rtas.c
>> +++ b/lib/powerpc/rtas.c
>> @@ -46,9 +46,9 @@ void rtas_init(void)
>>  	prop = fdt_get_property(dt_fdt(), node,
>>  				"linux,rtas-entry", &len);
>>  	if (!prop) {
>> -		printf("%s: /rtas/linux,rtas-entry: %s\n",
>> -				__func__, fdt_strerror(len));
>> -		abort();
>> +		/* We don't have a qemu provided RTAS blob, enter_rtas
>> +		 * will use H_RTAS directly */
>> +		return;
>>  	}
>>  	data = (u32 *)prop->data;
>>  	rtas_entry = (unsigned long)fdt32_to_cpu(*data);
>> diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
>> index ec673b3..972851f 100644
>> --- a/powerpc/cstart64.S
>> +++ b/powerpc/cstart64.S
>> @@ -121,13 +121,25 @@ halt:
>>  
>>  .globl enter_rtas
>>  enter_rtas:
>> +	LOAD_REG_ADDR(r11, rtas_entry)
>> +	ld	r10, 0(r11)
>> +
>> +	cmpdi	r10,0
>> +	bne	external_rtas
>> +
>> +	/* Use H_RTAS directly */
>> +	mr	r4,r3
>> +	lis	r3,KVMPPC_H_RTAS@h
>> +	ori	r3,r3,KVMPPC_H_RTAS@l
>> +	b	hcall
>> +
>> +external_rtas:
>> +	/* Use external RTAS blob */
>>  	mflr	r0
>>  	std	r0, 16(r1)
>>  
>> -	LOAD_REG_ADDR(r10, rtas_return_loc)
>> -	mtlr	r10
>> -	LOAD_REG_ADDR(r11, rtas_entry)
>> -	ld	r10, 0(r11)
>> +	LOAD_REG_ADDR(r11, rtas_return_loc)
>> +	mtlr	r11
>>  
>>  	mfmsr	r11
>>  	LOAD_REG_IMMEDIATE(r9, RTAS_MSR_MASK)
>>
> 
> With the typo in the commit message fixed:
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 
> Paolo, I currently don't have any other kvm-unit-test patches pending,
> could you pick this up directly, please?

Ok, thanks.

Paolo

