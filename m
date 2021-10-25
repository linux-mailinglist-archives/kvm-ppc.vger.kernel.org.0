Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB96F439B0E
	for <lists+kvm-ppc@lfdr.de>; Mon, 25 Oct 2021 18:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbhJYQDY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 25 Oct 2021 12:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbhJYQDX (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 25 Oct 2021 12:03:23 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C93AC061767
        for <kvm-ppc@vger.kernel.org>; Mon, 25 Oct 2021 09:01:01 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 83so5143819pgc.8
        for <kvm-ppc@vger.kernel.org>; Mon, 25 Oct 2021 09:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x6eNl6O1fSvFYqdMcRuePT95mvtM6NDjKvqXNkc5pYY=;
        b=W66VdzQAiFa1xER7EM1CT10+Eh4wcd9TMpOSeNztU9mQ/b+ICWh6L1ynZPC3b8cWCA
         wuqZ3JuK0JGehSxVwtqEbTHwrBlvK53p1U6E/+mtZAETvvOLRtbYFjLFwI5UloPxv8BN
         XlYir//YmeaaWdnkVyW1uxNuSu55EoKM4Sw+NhmN68wnM6lSDD7jC6Cq+yKsA+BDT9S7
         LYFfhy6YQg08/t+jqQY9xY27FLq7qZME+IYTw4bo6b7p4vRP0wxorg/00RAZqr4kWqI+
         VviR3lssvu74tKK3FhhWMgst1k6Zz5l/r1ahbN8uJfV8tyf6Q1Oq93E9u1/e6tuuAmnW
         0NsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x6eNl6O1fSvFYqdMcRuePT95mvtM6NDjKvqXNkc5pYY=;
        b=gCLh01Pvp6PFeo/ghwddpT4rNONBCry2XfBORMrxvQbbWhba+96xBVStYJoEfjOeVF
         Nfokwo/GLtQfkB7WsKl7NuFpI2I46cgv+8FPK3ufqLk45seyfab/7UCzb/rJgIeNu07x
         qE9pKAlJceUsgiPv4K0plC3jL1mDGFdJ77bNUGm6s87F+w7Hs3LldIPMKdkgGl1iBnP3
         DWgCgR5tP1Ctr9ZgruqF55QOVJIbk7MADTyRidLJReyjOt3EdXZAH+BIg+SSC1dI2vST
         XzZolDoRZH58L8JCizCBWmaqhKncIC7C50D/qhjRo5XVJHzSj1m5SOrfHUdb5Z42eYBP
         6r2g==
X-Gm-Message-State: AOAM533tn7JVzyIUR7wPdk/AwMkXbWxW7W9OMtBN9xqe4NCpnlwBA5vq
        tyxQdHCKNRbaJSCGLaLZl8XpJg==
X-Google-Smtp-Source: ABdhPJxfd0U6TdkD95vRyewvEnv+pkmAbt8gRM1KdKD5w9N0+9AMKZEnnSCWoZvj6xIN71v2dvngIg==
X-Received: by 2002:a63:e613:: with SMTP id g19mr14679139pgh.12.1635177660627;
        Mon, 25 Oct 2021 09:01:00 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a124sm2589630pgc.15.2021.10.25.09.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 09:01:00 -0700 (PDT)
Date:   Mon, 25 Oct 2021 16:00:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v2 37/43] KVM: SVM: Unconditionally mark AVIC as running
 on vCPU load (with APICv)
Message-ID: <YXbUuLD4yAoNxCH4@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-38-seanjc@google.com>
 <acea3c6d-49f4-ab5e-d9fe-6c6a8a665a46@redhat.com>
 <YXbRyMQgMpHVQa3G@google.com>
 <e9509fb0-54f3-ca86-57b7-8b6d5de240b7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9509fb0-54f3-ca86-57b7-8b6d5de240b7@redhat.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Oct 25, 2021, Paolo Bonzini wrote:
> On 25/10/21 17:48, Sean Christopherson wrote:
> > On Mon, Oct 25, 2021, Paolo Bonzini wrote:
> > > On 09/10/21 04:12, Sean Christopherson wrote:
> > > > +	/* TODO: Document why the unblocking path checks for updates. */
> > > 
> > > Is that a riddle or what? :)
> > 
> > Yes?  I haven't been able to figure out why the unblocking path explicitly
> > checks and handles an APICv update.
> > 
> 
> Challenge accepted.  In the original code, it was because without it
> avic_vcpu_load would do nothing, and nothing would update the IS_RUNNING
> flag.
> 
> It shouldn't be necessary anymore since commit df7e4827c549 ("KVM: SVM: call
> avic_vcpu_load/avic_vcpu_put when enabling/disabling AVIC", 2021-08-20),
> where svm_refresh_apicv_exec_ctrl takes care of the avic_vcpu_load on the
> next VMRUN.

Aha!  Thanks, I'll work in a removal for the next version.
