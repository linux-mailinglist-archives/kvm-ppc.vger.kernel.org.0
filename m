Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 835A2143BD0
	for <lists+kvm-ppc@lfdr.de>; Tue, 21 Jan 2020 12:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbgAULMW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Jan 2020 06:12:22 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36338 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729526AbgAULMR (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Jan 2020 06:12:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579605135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SUmH5ZMutw7kgyRL+tUGBiFKuqlrQTYA6wv/vKtVsig=;
        b=G7q5fiYD8qM//M4chYV+u63PkL2+2H1NDaYxxyu3QvlCGDtgItUkg4h3izASndIhSYJ6zw
        x77zfKjrWLAsyd8yNcg3Hxt6Kj/R+iFwu0p5CMTQOZBze1LaA/AHaNSInXk5Mkqy24ex+p
        K6Kdsb/2yc+ZXGBK2lzUZhg9v+tMsMg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-BH6_QheeO9KyfLWN4UIV3g-1; Tue, 21 Jan 2020 06:12:13 -0500
X-MC-Unique: BH6_QheeO9KyfLWN4UIV3g-1
Received: by mail-wr1-f69.google.com with SMTP id z15so1174864wrw.0
        for <kvm-ppc@vger.kernel.org>; Tue, 21 Jan 2020 03:12:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SUmH5ZMutw7kgyRL+tUGBiFKuqlrQTYA6wv/vKtVsig=;
        b=lm1ijWfDi2vxeNU1xuS9LFk0onJnAsRwf8rKfb4s+RD9QXKL3woAP+N51n102FCDET
         qgHc99M1lnufmeOAfe1AmoCkHxJq0DSjGmhbo23J+FgGZ32whQrLwW8LIKqjSt83zetM
         1wd8ao3s13BhGbYbN9jij2H4gV+rNOPRsUVCYs09Dxe7AYFj69w2ICZh1pmcBuTzzvti
         ZMbcbrYdGpdtu9aVkYYoRimf9EUQp2hNGh5P6VuuvH96iHYmTsbJxCSIl8JmtPlL433B
         WoNoBprq13AVhe5so/+xNImZ0vusKfGHRaoAsm/ijUs7vewp3OVV4I2eq9p3r4W/GYM+
         ENkQ==
X-Gm-Message-State: APjAAAXAovVwxNBM2zHGCzxKmN+lkAnzHThekxklWWawuQQo/ap/E/GW
        PF13JZHo0D2QW9+wdzubTgJBaOjQHYi0i+s2twYcVu78qXVQer3XQjjYIS2bcJuyrFtwTrTWQ4M
        UsL2oEMvS5luDMMOIbA==
X-Received: by 2002:a05:6000:11c9:: with SMTP id i9mr4806236wrx.164.1579605131966;
        Tue, 21 Jan 2020 03:12:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqypfAKKGH/a848HhEdWp/8kNPn20JC8kc1fEqjae+lABJTb9oaxjSSRLWrYZHNDzVwQwM45Kg==
X-Received: by 2002:a05:6000:11c9:: with SMTP id i9mr4806191wrx.164.1579605131619;
        Tue, 21 Jan 2020 03:12:11 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id z8sm51076203wrq.22.2020.01.21.03.12.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 03:12:11 -0800 (PST)
Subject: Re: [PATCH v2 41/45] KVM: PPC: Move all vcpu init code into
 kvm_arch_vcpu_create()
To:     Paul Mackerras <paulus@ozlabs.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kurz <groug@kaod.org>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-42-sean.j.christopherson@intel.com>
 <20200120034658.GD14307@blackberry>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d3d465b0-6a45-c754-0538-1e4d1e130357@redhat.com>
Date:   Tue, 21 Jan 2020 12:12:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200120034658.GD14307@blackberry>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 20/01/20 04:46, Paul Mackerras wrote:
> On Wed, Dec 18, 2019 at 01:55:26PM -0800, Sean Christopherson wrote:
>> Fold init() into create() now that the two are called back-to-back by
>> common KVM code (kvm_vcpu_init() calls kvm_arch_vcpu_init() as its last
>> action, and kvm_vm_ioctl_create_vcpu() calls kvm_arch_vcpu_create()
>> immediately thereafter).  Rinse and repeat for kvm_arch_vcpu_uninit()
>> and kvm_arch_vcpu_destroy().  This paves the way for removing
>> kvm_arch_vcpu_{un}init() entirely.
>>
>> Note, calling kvmppc_mmu_destroy() if kvmppc_core_vcpu_create() fails
>> may or may not be necessary.  Move it along with the more obvious call
>> to kvmppc_subarch_vcpu_uninit() so as not to inadvertantly introduce a
>> functional change and/or bug.
>>
>> No functional change intended.
>>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> This doesn't compile.  I get:
> 
>   CC [M]  arch/powerpc/kvm/powerpc.o
> /home/paulus/kernel/kvm/arch/powerpc/kvm/powerpc.c: In function ‘kvm_arch_vcpu_create’:
> /home/paulus/kernel/kvm/arch/powerpc/kvm/powerpc.c:733:34: error: ‘kvmppc_decrementer_wakeup’ undeclared (first use in this function)
>   vcpu->arch.dec_timer.function = kvmppc_decrementer_wakeup;
>                                   ^
> /home/paulus/kernel/kvm/arch/powerpc/kvm/powerpc.c:733:34: note: each undeclared identifier is reported only once for each function it appears in
> /home/paulus/kernel/kvm/arch/powerpc/kvm/powerpc.c: At top level:
> /home/paulus/kernel/kvm/arch/powerpc/kvm/powerpc.c:794:29: warning: ‘kvmppc_decrementer_wakeup’ defined but not used [-Wunused-function]
>  static enum hrtimer_restart kvmppc_decrementer_wakeup(struct hrtimer *timer)
>                              ^
> make[3]: *** [/home/paulus/kernel/kvm/scripts/Makefile.build:266: arch/powerpc/kvm/powerpc.o] Error 1
> 
> The problem is that kvmppc_decrementer_wakeup() is a static function
> defined in this file (arch/powerpc/kvm/powerpc.c) after
> kvm_arch_vcpu_create() but before kvm_arch_vcpu_init().  You need a
> forward static declaration of kvmppc_decrementer_wakeup() before
> kvm_arch_vcpu_create(), or else move one or other function.
> 
> Paul.
> 

Squashed:

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 91cf94d4191e..4fbf8690b8c5 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -725,6 +725,16 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return 0;
 }
 
+static enum hrtimer_restart kvmppc_decrementer_wakeup(struct hrtimer *timer)
+{
+	struct kvm_vcpu *vcpu;
+
+	vcpu = container_of(timer, struct kvm_vcpu, arch.dec_timer);
+	kvmppc_decrementer_func(vcpu);
+
+	return HRTIMER_NORESTART;
+}
+
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	int err;
@@ -791,16 +801,6 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 	return kvmppc_core_pending_dec(vcpu);
 }
 
-static enum hrtimer_restart kvmppc_decrementer_wakeup(struct hrtimer *timer)
-{
-	struct kvm_vcpu *vcpu;
-
-	vcpu = container_of(timer, struct kvm_vcpu, arch.dec_timer);
-	kvmppc_decrementer_func(vcpu);
-
-	return HRTIMER_NORESTART;
-}
-
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	return 0;

Paolo

