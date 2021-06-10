Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8833A2B4B
	for <lists+kvm-ppc@lfdr.de>; Thu, 10 Jun 2021 14:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhFJMT1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 10 Jun 2021 08:19:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24962 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230265AbhFJMT0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 10 Jun 2021 08:19:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623327450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uv0xs33ewLzq+ryxudIHULBGFCkV88+uHAen7THruNI=;
        b=FAsBBbNjCcaMTi22JwkTiFRwVkiaKSQQDJNjEu9MFmvDFk85EGKP1zhMIFtGE4GeFCuloD
        MrGjIukbFzaD26ieM6J23h1updP44IgdKqbqHgSiHiOA7UlDQ7Zlo+WwKuPTZuLCc083P1
        IsIpy10fqAsGX+rloa4PlXzYfl6AAQo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-C_LD9CEhMAKT2zbl-a5lDw-1; Thu, 10 Jun 2021 08:17:25 -0400
X-MC-Unique: C_LD9CEhMAKT2zbl-a5lDw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EDAB8042B7;
        Thu, 10 Jun 2021 12:17:24 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9EEFC18B42;
        Thu, 10 Jun 2021 12:17:19 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 0/7] unify header guards
Date:   Thu, 10 Jun 2021 08:17:19 -0400
Message-Id: <162332742682.173232.8556399043091141939.b4-ty@redhat.com>
In-Reply-To: <20210609143712.60933-1-cohuck@redhat.com>
References: <20210609143712.60933-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 9 Jun 2021 16:37:05 +0200, Cornelia Huck wrote:
> This is an extension of "s390x: unify header guards" to the rest
> of kvm-unit-tests. I tried to choose a pattern that minimizes the
> changes; most of them are for s390x and x86.
> 
> v1->v2:
> - change the patterns and document them
> - change other architectures and architecture-independent code as well
> 
> [...]

Applied, thanks!

[1/7] README.md: add guideline for header guards format
      commit: 844669a9631d78a54b47f6667c9a2750b65d101c
[2/7] lib: unify header guards
      commit: 9f0ae3012430ed7072d04247fb674125c616a6b4
[3/7] asm-generic: unify header guards
      commit: 951e6299b30016bf04a343973296c4274e87f0e2
[4/7] arm: unify header guards
      commit: 16f52ec9a4763e62e35453497e4f077031abcbfb
[5/7] powerpc: unify header guards
      commit: 040ee6d9aee563b2b1f28e810c5e36fbbcc17bd9
[6/7] s390x: unify header guards
      commit: eb5a1bbab00619256b76177e7a88cfe05834b026
[7/7] x86: unify header guards
      commit: c865f654ffe4c5955038aaf74f702ba62f3eb014

Best regards,
-- 
Paolo Bonzini <pbonzini@redhat.com>

