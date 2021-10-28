Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D4243E5D6
	for <lists+kvm-ppc@lfdr.de>; Thu, 28 Oct 2021 18:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhJ1QOg (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 28 Oct 2021 12:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbhJ1QOf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 28 Oct 2021 12:14:35 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C09C0613B9
        for <kvm-ppc@vger.kernel.org>; Thu, 28 Oct 2021 09:12:08 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s136so6862074pgs.4
        for <kvm-ppc@vger.kernel.org>; Thu, 28 Oct 2021 09:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uDFUXcWiQOAZszlFDFiKgSiJL9HB/WuFg2qPOmsqC9E=;
        b=s8JT5njEusSpDvvGXpDQ9LZlankma9a4yiSWD9KOohfnBHlxyPNl/U/08pekLcb/bC
         ovoSobTTd28f9TmLEDOEfxcyphCFmhjuM9+ON0HPn4qn8BCTN2ldIPxu2jDowg4XqJu6
         3xH28lP4FssgtQ0ca7hD6ajCl1FxkivUDYuXRLmLx2Yi3tCCzZXargRA7TY8R9VN5f+Z
         OVvgBrcUFyQ3a4VjcEcymihbaDJ3t1+Gwm46k3BuLJXPbEryRKF1JBLikEHoHCefGv/7
         I7zNR4Q9EXiCvnW7HnxhjPhNdV9zeEX0aTdpBRV58BMvHDUDx6AGdT+87VVv7qJ97TcC
         uARw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uDFUXcWiQOAZszlFDFiKgSiJL9HB/WuFg2qPOmsqC9E=;
        b=v+Ih6wP3NLCWJTHCVvHEXxUOIG7inMNqXIf2AD1C6AEB9Tp8LeIV0uHKbHjD0kKj28
         T2rRlwzNMet97so6veeYfQnMiS3VGyUe6/4pDZQgs/IdO6SRFnhl4WZZt/5q9vjdfehS
         tgLo5kZHunwDlmambPNbR3fNDAZvtj3U5SDs5luYcfPngveVdskuEjDOvRVQg/oNq8HH
         afD1pjyIc47AL3ES0mwSHvelKwHmUYIrEV3LK23XdcisNBes28rqQvDnFpB3YGBiavHS
         0XsMPLGl6mY7LlVnMlXCP9ttQcwh5XdHtu0N4bV/KeU+u2rPZqlYVyJyV4UIAgaR0mpp
         cAiA==
X-Gm-Message-State: AOAM532feTFf+zU0CFxn7woP5biI4fXlTo93ehRpcXfIebu+1lnU6bKo
        ZcZJ/0Q5peXsTADKbe9GkeyTPw==
X-Google-Smtp-Source: ABdhPJzctFKuSMS4ABMglKZzvBYXQnPOjA4L7dQsvoAPPXlll55VtYD46hr5Zh0pXIPugFNW+Dl/hA==
X-Received: by 2002:a05:6a00:1709:b0:47e:493e:ca5f with SMTP id h9-20020a056a00170900b0047e493eca5fmr4461870pfc.60.1635437528216;
        Thu, 28 Oct 2021 09:12:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f7sm4329616pfv.152.2021.10.28.09.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 09:12:07 -0700 (PDT)
Date:   Thu, 28 Oct 2021 16:12:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: Re: [PATCH v2 27/43] KVM: VMX: Move Posted Interrupt ndst
 computation out of write loop
Message-ID: <YXrL1EuzZtTR4J1Q@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-28-seanjc@google.com>
 <643d9c249b5863f04290a6f047ea1a2d98bd75f9.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <643d9c249b5863f04290a6f047ea1a2d98bd75f9.camel@redhat.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Oct 28, 2021, Maxim Levitsky wrote:
> On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> > Hoist the CPU => APIC ID conversion for the Posted Interrupt descriptor
> > out of the loop to write the descriptor, preemption is disabled so the
> > CPU won't change, and if the APIC ID changes KVM has bigger problems.
> > 
> > No functional change intended.
> 
> Is preemption always disabled in vmx_vcpu_pi_load? vmx_vcpu_pi_load is called
> from vmx_vcpu_load, which is called indirectly from vcpu_load which is called
> from many ioctls, which userspace does. In these places I don't think that
> preemption is disabled.

Preemption is disabled in vcpu_load() by the get_cpu().  The "cpu" param that's
passed around the vcpu_load() stack is also why I think it's ok to _not_ assert
that preemption is disabled in vmx_vcpu_pi_load(); if preemption is enabled,
"cpu" is unstable and thus the entire "load" operation is busted.


#define get_cpu()		({ preempt_disable(); __smp_processor_id(); })
#define put_cpu()		preempt_enable()


void vcpu_load(struct kvm_vcpu *vcpu)
{
	int cpu = get_cpu();

	__this_cpu_write(kvm_running_vcpu, vcpu);
	preempt_notifier_register(&vcpu->preempt_notifier);
	kvm_arch_vcpu_load(vcpu, cpu);
	put_cpu();
}
EXPORT_SYMBOL_GPL(vcpu_load);
