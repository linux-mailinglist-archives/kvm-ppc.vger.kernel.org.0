Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F22B3A1A13
	for <lists+kvm-ppc@lfdr.de>; Wed,  9 Jun 2021 17:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhFIPte (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 9 Jun 2021 11:49:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50006 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235855AbhFIPtc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 9 Jun 2021 11:49:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623253657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HrJ56KNgOU02CakepH78uzRXCKVfyAtnPm/2ZtxoPPI=;
        b=J+GyYgkKO5AMVf3ZeNlhHyfNouABgSFSPfNdatI4TpZYAFqOLDnUjF7w1t5s9GBFMhpqMl
        AEG8AA0SbQZDl6vop0ing3g/PY0aM6qt0psGPeOlIpVUoHgsd4BOfGe6Z1tthaVem4bpt0
        5N9dKS4za7daHDyf191H6sLJUUv1Jpc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-0PxVCkv8ND-DEVJNQY53gQ-1; Wed, 09 Jun 2021 11:47:36 -0400
X-MC-Unique: 0PxVCkv8ND-DEVJNQY53gQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 798941922960;
        Wed,  9 Jun 2021 15:47:34 +0000 (UTC)
Received: from localhost (ovpn-113-134.ams2.redhat.com [10.36.113.134])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 04E0B5D9C6;
        Wed,  9 Jun 2021 15:47:30 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Laurent Vivier <lvivier@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 4/7] arm: unify header guards
In-Reply-To: <8399161a-ef26-7d4f-19fb-c54ca40fe6c3@redhat.com>
Organization: Red Hat GmbH
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-5-cohuck@redhat.com>
 <8399161a-ef26-7d4f-19fb-c54ca40fe6c3@redhat.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Wed, 09 Jun 2021 17:47:29 +0200
Message-ID: <874ke711m6.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Jun 09 2021, Laurent Vivier <lvivier@redhat.com> wrote:

> On 09/06/2021 16:37, Cornelia Huck wrote:
>> The assembler.h files were the only ones not already following
>> the convention.
>> 
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  lib/arm/asm/assembler.h   | 6 +++---
>>  lib/arm64/asm/assembler.h | 6 +++---
>>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> What about lib/arm/io.h?

It didn't have a guard yet, so I didn't touch it.

>
> I think you can remove the guard from
>
> lib/arm/asm/memory_areas.h
>
> as the other files including directly a header doesn't guard it.

I see other architectures doing that, though. I guess it doesn't hurt,
but we can certainly also remove it. Other opinions?

>
> Missing lib/arm/asm/mmu-api.h, lib/arm/asm/mmu.h, lib/arm64/asm/mmu.h

Oops, overlooked the extra underscore there.

