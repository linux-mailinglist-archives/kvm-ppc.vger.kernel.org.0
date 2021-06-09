Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0493A1A34
	for <lists+kvm-ppc@lfdr.de>; Wed,  9 Jun 2021 17:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237380AbhFIPxn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 9 Jun 2021 11:53:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56808 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237377AbhFIPxj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 9 Jun 2021 11:53:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623253905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AlPS4g9klGGODfdBQvh17uuQojemuSkP0oW9AXtfw0Y=;
        b=NLbAHwWt89Z0IUY2KczHH6fnQtvL4bhAIXpi/4YNSAORffOrjiMzjIEED9pfpaVLGHMy7G
        NuYr2ROYO0Ytho87l4MgoE24kS6zp+Etbn2QKbQPlwTo/bzYJcR7GxmNaLshPrE7sJANIN
        3HNvcM1doSkCLMgVpsk2rNk4zYsYmBI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-sjedR2EdM96_rQA9BdWv9w-1; Wed, 09 Jun 2021 11:51:41 -0400
X-MC-Unique: sjedR2EdM96_rQA9BdWv9w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1133801FCD;
        Wed,  9 Jun 2021 15:51:40 +0000 (UTC)
Received: from [10.36.112.148] (ovpn-112-148.ams2.redhat.com [10.36.112.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C7CA5D6AD;
        Wed,  9 Jun 2021 15:51:34 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 4/7] arm: unify header guards
To:     Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-5-cohuck@redhat.com>
 <8399161a-ef26-7d4f-19fb-c54ca40fe6c3@redhat.com> <874ke711m6.fsf@redhat.com>
From:   Laurent Vivier <lvivier@redhat.com>
Message-ID: <233f8a97-146e-3a75-9447-d5155a0dd7c9@redhat.com>
Date:   Wed, 9 Jun 2021 17:51:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <874ke711m6.fsf@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 09/06/2021 17:47, Cornelia Huck wrote:
> On Wed, Jun 09 2021, Laurent Vivier <lvivier@redhat.com> wrote:
> 
>> On 09/06/2021 16:37, Cornelia Huck wrote:
>>> The assembler.h files were the only ones not already following
>>> the convention.
>>>
>>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>> ---
>>>  lib/arm/asm/assembler.h   | 6 +++---
>>>  lib/arm64/asm/assembler.h | 6 +++---
>>>  2 files changed, 6 insertions(+), 6 deletions(-)
>>
>> What about lib/arm/io.h?
> 
> It didn't have a guard yet, so I didn't touch it.
> 
>>
>> I think you can remove the guard from
>>
>> lib/arm/asm/memory_areas.h
>>
>> as the other files including directly a header doesn't guard it.
> 
> I see other architectures doing that, though. I guess it doesn't hurt,
> but we can certainly also remove it. Other opinions?

It doesn't hurt to remove it but I think what is important is to have the same rule
everywhere.

Thanks,
Laurent


