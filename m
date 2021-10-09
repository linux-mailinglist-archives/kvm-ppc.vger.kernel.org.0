Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF94A42764F
	for <lists+kvm-ppc@lfdr.de>; Sat,  9 Oct 2021 04:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244705AbhJICSI (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 8 Oct 2021 22:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244540AbhJICRr (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 8 Oct 2021 22:17:47 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BE7C0613B4
        for <kvm-ppc@vger.kernel.org>; Fri,  8 Oct 2021 19:14:04 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z130-20020a256588000000b005b6b4594129so15100830ybb.15
        for <kvm-ppc@vger.kernel.org>; Fri, 08 Oct 2021 19:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=C2PBzYfpswTkvsOYeskWQEML51RRougebHfj0Alyx5A=;
        b=WYMPTsMzDt+AsjiCyZJ1B4+ZpYxh2OtDt82Ju6kAg5cXo6tqXm1ZgRYGEPixBeGSUX
         csu0nnUcxqKDiQ1eAmAeGes+LUQg2mXWzAyCEZN0ncq8JRJRFlJFF87rnbemqyBf6tBd
         V9ViKRAH1hB1quUnaDowk1/9kTi2JyNnkHWTKfzzmhY7AxslA7BLbxo1ZA8eLcYWLnjz
         YbQ0w447PhslHJ3ZxBNJRnTcGLYtNfmZQAOeWXXJuualGN4NlLQe9GK7rEtrWgH0mtsp
         VqsmagApekmgICqy79O2umIOGpnKlEqjA71PkSs0Bk91M4cBLEAn1bGCQe9gx+1d5Zvx
         1xGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=C2PBzYfpswTkvsOYeskWQEML51RRougebHfj0Alyx5A=;
        b=7xyUzf4znAN8kO/UPuaDC8HcGP/D7YN9lLBwbmjQAntXlAkqZ/yh0lb4+EWWVJu+Wu
         z0shpdQVrWG5jhQx0mQYua0Nk54WmpdBTv7ByUNSuhSDvZtbfObCX8YDY3sMeF3eCXJK
         soEOcHjHtHGJO0OLe8yZ4saCYUPLFiwcTaXi9KlEfAP0oe5gNCYWX6Ov7L4QwqEfeS3j
         XHxOMSMv2X3p22k3XMVSENy0Sc1S0aVLA67+9PKQgtuYut41sjr+ug86OzIqxlwFYw1u
         Wj8S6S9miriZ7buM4nVNXFwPaynGGNu9ve69Re0tHX45BmCio0BI8cuJ2A+Oal9Krpkl
         LoXQ==
X-Gm-Message-State: AOAM532yiOmosPOdeAaBDQ99igL2/qJehC8CJqIlZYVmuxNbp8xQjiZu
        Cc/BQlicf67NHc9lyj5b2D6wZf4MQCc=
X-Google-Smtp-Source: ABdhPJzcpn5DTPQuPSfZUPDLuPAfkBrPTcc8cEPmAKwjDwkk0IcaBIdBFMmznx5JjVGnWgQQ1Ay+qs9Sp8s=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:5954:: with SMTP id n81mr7136674ybb.435.1633745643213;
 Fri, 08 Oct 2021 19:14:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:12:26 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-34-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 33/43] KVM: x86: Unexport LAPIC's switch_to_{hv,sw}_timer() helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Unexport switch_to_{hv,sw}_timer() now that common x86 handles the
transitions.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0cd7ed21b205..cfb64bd4a1c1 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1948,7 +1948,6 @@ void kvm_lapic_switch_to_hv_timer(struct kvm_vcpu *vcpu)
 {
 	restart_apic_timer(vcpu->arch.apic);
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_switch_to_hv_timer);
 
 void kvm_lapic_switch_to_sw_timer(struct kvm_vcpu *vcpu)
 {
@@ -1960,7 +1959,6 @@ void kvm_lapic_switch_to_sw_timer(struct kvm_vcpu *vcpu)
 		start_sw_timer(apic);
 	preempt_enable();
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_switch_to_sw_timer);
 
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu)
 {
-- 
2.33.0.882.g93a45727a2-goog

