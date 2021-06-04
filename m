Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FDD39AF1F
	for <lists+kvm-ppc@lfdr.de>; Fri,  4 Jun 2021 02:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhFDAmX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 3 Jun 2021 20:42:23 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:35338 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFDAmW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 3 Jun 2021 20:42:22 -0400
Received: by mail-pl1-f181.google.com with SMTP id t21so3783153plo.2
        for <kvm-ppc@vger.kernel.org>; Thu, 03 Jun 2021 17:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hsyO5EEm3dG2GUVsZApwZQUFiUjt1oJTpcTgXFZNdfs=;
        b=BlYNVPE305FbxEUMO5lSCEn5LG3JutO1Lg3tWns9s0oCrpDQwG+i6qmuM/hisKYpP+
         y5qZfeRJIC4++esHrRYMFwklEwa2AsIP8FI2G+izcydAmHDQpIvGWGtM265YiTqVep0S
         1wPk4/uTSpfKNxeIwC0sNPU2Zfv4gAByw74Ls=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hsyO5EEm3dG2GUVsZApwZQUFiUjt1oJTpcTgXFZNdfs=;
        b=NzRr0CSRLSUsjnUbDELOeEynfM71OcWelPSCpZKHtbYDAqwRddWpYNHZYHutA7smPR
         s55W792+GAD8mzKIQFFTa1fo/JXDPa0K1Q4pUB3e0hBp80cCNLj9DLUYoFB+/e7Tvt97
         LDFFaUIe3DTG0b0D4OshpHBo5TOEpjNaiKAn94StimxzA+javUwyS12EslzFsXOEq9ej
         YRj6NXdFOhqJmxjUMDH7aljxkFOHvRX3V69Mn5bWa6jSqzTzKRK6mcmHe65BHA0oRKsq
         N25lha1NM+CQopMfpwK8/tN4PffDT9cRZmbnms5NDd4tWDN10+MAY8SA9A8DwzHDER3+
         NePg==
X-Gm-Message-State: AOAM533tzp4fTj2VAZgfKOpi//6MbifUSZkILBd/HVKph+rWRMHSQvKk
        621J+76sPTVZ0M0mpcY95WPR4g==
X-Google-Smtp-Source: ABdhPJwUR3L1tC9qXtsxtXxpLe8tNcJAE3/COLahbUTOQi2i1KnLOCdr6jBvw3P/Ytpi3HasD6ls1Q==
X-Received: by 2002:a17:90a:7345:: with SMTP id j5mr13827315pjs.64.1622767177417;
        Thu, 03 Jun 2021 17:39:37 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:36b:f5b6:c380:9ccf])
        by smtp.gmail.com with ESMTPSA id j16sm3074017pjn.55.2021.06.03.17.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 17:39:36 -0700 (PDT)
Date:   Fri, 4 Jun 2021 09:39:29 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Suleiman Souhlal <suleiman@google.com>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [RFC][PATCH] kvm: add suspend pm-notifier
Message-ID: <YLl2QeoziEVHvRAO@google.com>
References: <20210603164315.682994-1-senozhatsky@chromium.org>
 <YLkRB3qxjrXB99He@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLkRB3qxjrXB99He@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On (21/06/03 19:27), Peter Zijlstra wrote:
> On Fri, Jun 04, 2021 at 01:43:15AM +0900, Sergey Senozhatsky wrote:
[..]
> >  
> > +void kvm_arch_pm_notifier(struct kvm *kvm)
> > +{
> > +}
> > +
> >  long kvm_arch_vm_ioctl(struct file *filp,
> >  		       unsigned int ioctl, unsigned long arg)
> >  {
> 
> What looks like you wants a __weak function.

True. Thanks for the suggestion.

I thought about it, but I recalled that tglx had  __strong opinions
on __weak functions.
