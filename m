Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46A6419788
	for <lists+kvm-ppc@lfdr.de>; Mon, 27 Sep 2021 17:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbhI0PRi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 27 Sep 2021 11:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbhI0PRh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 27 Sep 2021 11:17:37 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EDEC061604
        for <kvm-ppc@vger.kernel.org>; Mon, 27 Sep 2021 08:15:59 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id k23so12704043pji.0
        for <kvm-ppc@vger.kernel.org>; Mon, 27 Sep 2021 08:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J1aK1o24WWHw6k8idRjv4JjH9S5sZVXgl07HpLc8Nnw=;
        b=bQHxGWLkKAFfWjndxT1kv2LbZGzPIP4GMYqRTXgFhjFtycMwHf7oDbkLslbtR4pYd8
         yoFlCQc2ltGwam4vhlmoS3oimleu3pwe0TB2wEbQSMXNmcuSL2fEXMGKRR6VGAEKa+zx
         uBEyDrGhON68VlaGnkxqoD7VEINLMPpIUFZaO91NQhTftbZgCwvv8fSwFTGkn60+vb7M
         tzXRg07NdSFlGR9MnkHpbvjCWdgeDDxSzPrXKbohkx6P3LAtIvvQcCO2/whyo9eVK5YX
         lBKDG/n38SBu32xRrec0Hya+F6UV+98jAPrLz4eDF/C+dn9e2QJw1OXHZ3z9XcorwHMQ
         JAPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J1aK1o24WWHw6k8idRjv4JjH9S5sZVXgl07HpLc8Nnw=;
        b=vAnR1yGy4EJbAx76NP6+aXaQjse6Zza0/nWoTNUIEwn1owv+o2SmV7koNrQbQWTEmS
         plI1+4QqZD7MDAmnNZ3tg88JMqPzE9kgLmLJkhk1pTa7nMHRWJC4Yw8HS5G7+cuZtZfg
         /JwhvjnMB08KU0SJNfutUlQWQR3w9F4nX147TvoZxRoH+oOVS5kA8xSyvwTUFM84fsk7
         qPFEgaTNUJJPaqPmi12MOdE4X610AdxA79r1ar1JUaN3o/GynOdBOf8HfqgIDEgvcqnD
         U0D0im980oPUBZsByTCRuewFbJEWbfe9WOHyNxjGecnJGF/QpL3ROYUAghsh/mPymfrw
         wdBg==
X-Gm-Message-State: AOAM531FhhcmlMm+g4v/VGgiJtEP4GbtZXMXGcEX5kQ9dTfrgDGy3xoc
        Q4ioipVQJhVHEDS5mU5mUkfFgA==
X-Google-Smtp-Source: ABdhPJyA6ONhd1Ga93hKwsqmjOKuFVk7/BNXzU8fonL5kd5O9SJ41kUDv10GPB3TNvNBUBEzEJ7IZA==
X-Received: by 2002:a17:90a:4207:: with SMTP id o7mr523060pjg.192.1632755758626;
        Mon, 27 Sep 2021 08:15:58 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id r23sm20063784pjo.3.2021.09.27.08.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 08:15:57 -0700 (PDT)
Date:   Mon, 27 Sep 2021 15:15:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        David Matlack <dmatlack@google.com>,
        Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: disabling halt polling broken? (was Re: [PATCH 00/14] KVM:
 Halt-polling fixes, cleanups and a new stat)
Message-ID: <YVHgKWiU9WWL9ACg@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <03f2f5ab-e809-2ba5-bd98-3393c3b843d2@de.ibm.com>
 <YVHcY6y1GmvGJnMg@google.com>
 <f37ab68c-61ce-b6fb-7a49-831bacfc7424@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f37ab68c-61ce-b6fb-7a49-831bacfc7424@redhat.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Sep 27, 2021, Paolo Bonzini wrote:
> On 27/09/21 16:59, Sean Christopherson wrote:
> > > commit acd05785e48c01edb2c4f4d014d28478b5f19fb5
> > > Author:     David Matlack<dmatlack@google.com>
> > > AuthorDate: Fri Apr 17 15:14:46 2020 -0700
> > > Commit:     Paolo Bonzini<pbonzini@redhat.com>
> > > CommitDate: Fri Apr 24 12:53:17 2020 -0400
> > > 
> > >      kvm: add capability for halt polling
> > > 
> > > broke the possibility for an admin to disable halt polling for already running KVM guests.
> > > In past times doing
> > > echo 0 > /sys/module/kvm/parameters/halt_poll_ns
> > > 
> > > stopped polling system wide.
> > > Now all KVM guests will use the halt_poll_ns value that was active during
> > > startup - even those that do not use KVM_CAP_HALT_POLL.
> > > 
> > > I guess this was not intended?
> 
> No, but...
> 
> > I would go so far as to say that halt_poll_ns should be a hard limit on
> > the capability
> 
> ... this would not be a good idea I think.  Anything that wants to do a lot
> of polling can just do "for (;;)".

Hmm, true, there is no danger to the system in having the capability override the
module param.

> So I think there are two possibilities that makes sense:
> 
> * track what is using KVM_CAP_HALT_POLL, and make writes to halt_poll_ns
> follow that

I think this option makes more sense, making halt_poll_ns read-only is basically
forcing users to switch to KVM_CAP_HALT_POLL.

> * just make halt_poll_ns read-only.
> 
> Paolo
>
