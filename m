Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF3C39B5E2
	for <lists+kvm-ppc@lfdr.de>; Fri,  4 Jun 2021 11:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhFDJZJ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 4 Jun 2021 05:25:09 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:41776 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbhFDJZJ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 4 Jun 2021 05:25:09 -0400
Received: by mail-pg1-f176.google.com with SMTP id r1so7376121pgk.8
        for <kvm-ppc@vger.kernel.org>; Fri, 04 Jun 2021 02:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pcVIrrrWEUuSA+N6NdZCH+jzIyXyj1HQeo01ZwpdXxY=;
        b=T6vUk/4jMaY1sFB+ktO56Tu+hSYK1wiZBd79Qpkt7cR3wdk6RgqpEA+MqmoApExn4u
         Ki+XTdzY1lKdvlx+de9gaG+wdCW5+FLPTTH3w22d8er65zizi+PUDGgUHvaCEEPTouoT
         LUIBuV5Az0wlga/c+czm/LVkend9CKDw/kZwQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pcVIrrrWEUuSA+N6NdZCH+jzIyXyj1HQeo01ZwpdXxY=;
        b=WFGnInDFgHD+6qFvt5IEOUCnu0s1gCvK5gqWuZKmF6tAKgkbmoE6REf7i3eon9AHaK
         6LcylkSjW5EvfLaBZcn+St00B6pK+8NZ6IiCU60Q4nJDU8x3glyLp1339TFW9jYzRbBO
         L+Lj5xzS5RObH4LgeXWXGKuOtmd8ASGQKFRg1zbrMW6h51RQbxlRGyGYSul56/uMfoH1
         YYzovFbox/y9keQCF6qUWrbZCJokvxklnMVkvCgicDCkKNU5Z8BL0ZBysPY7DDKIw4bI
         MXq8ciZ/Ty2zbkImfbOTZYBT5WITTU5iDwCTtrsLeoaS5veh3tHTMFfuL1N5n+gbW/oK
         pH5A==
X-Gm-Message-State: AOAM533ylFKPw82kSM1Tuq/Fb4w5uD8zHiqwOOPIHjh9vODp8GebeJ/4
        sQxsk0JyVSapHsn2l+nCPmMyDg==
X-Google-Smtp-Source: ABdhPJyN+y7mCRzpjZlapAyCgZr6LbpUALEaLKem6t6vFwqQAQV8qZmVYl6DOYQnER784of3HxKE+Q==
X-Received: by 2002:aa7:82cb:0:b029:2e6:f397:d248 with SMTP id f11-20020aa782cb0000b02902e6f397d248mr3647517pfn.52.1622798529641;
        Fri, 04 Jun 2021 02:22:09 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:36b:f5b6:c380:9ccf])
        by smtp.gmail.com with ESMTPSA id d15sm4208168pjr.47.2021.06.04.02.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 02:22:09 -0700 (PDT)
Date:   Fri, 4 Jun 2021 18:22:02 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Suleiman Souhlal <suleiman@google.com>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC][PATCH] kvm: add suspend pm-notifier
Message-ID: <YLnwum6AtcURNlRL@google.com>
References: <20210603164315.682994-1-senozhatsky@chromium.org>
 <87a6o614dn.fsf@vitty.brq.redhat.com>
 <e4b4e872-4b22-82b7-57fc-65a7d10482c0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4b4e872-4b22-82b7-57fc-65a7d10482c0@redhat.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On (21/06/04 09:24), Paolo Bonzini wrote:
> On 04/06/21 09:21, Vitaly Kuznetsov wrote:
> > >   	preempt_notifier_inc();
> > > +	kvm_init_pm_notifier(kvm);
> > You've probably thought it through and I didn't but wouldn't it be
> > easier to have one global pm_notifier call for KVM which would go
> > through the list of VMs instead of registering/deregistering a
> > pm_notifier call for every created/destroyed VM?
> 
> That raises questions on the locking, i.e. if we can we take the kvm_lock
> safely from the notifier.

Right, I wanted to take the VM lock, rather than subsystem lock
(kvm_lock).
