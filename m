Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E657417EF6
	for <lists+kvm-ppc@lfdr.de>; Sat, 25 Sep 2021 02:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346911AbhIYA6i (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 24 Sep 2021 20:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346622AbhIYA6V (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 24 Sep 2021 20:58:21 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41B8C0617BE
        for <kvm-ppc@vger.kernel.org>; Fri, 24 Sep 2021 17:55:59 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id j4-20020ad454c4000000b0037a900dda7aso43166813qvx.14
        for <kvm-ppc@vger.kernel.org>; Fri, 24 Sep 2021 17:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=AVRxITHRgpiea0PQRu71hObIdpCCXd1tddFTuoKEd5M=;
        b=AmZZR6+/WobaV3d/KTMW3XEm+/mJU1HTP/alrco2LxeX8sPbzL7l8R5VIEq9wXYyp7
         P31gfDlcRexYcYK12mPrGpQSHiwq1+7jjMKOfcgumO3thuYh7379U579a8VXzaHynz/c
         Q3KQVXVmXyM9LNzIQGRL46YsUVsNUTTA436JsJh3i+G14dKyyalUZ6UHTH5GdEZXjP9r
         IiNGv+ok9CwUCbLkrQ6KhkOVblpqSFVi+lqel510DljUqO6ykZ33BWRlVYKAV98E9Pb3
         w2kY0mdXtU63LGRjV1zY+2LpQRo0iJs3knGrr124qdmj7QQ2lJ+zuHgXzPFrmiw1XkSd
         zSxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=AVRxITHRgpiea0PQRu71hObIdpCCXd1tddFTuoKEd5M=;
        b=5VBsSOGADaXUlReIzC/794bF8/VtEm/yvQfEBN2JU67oVa04fETZIt4S4i2+wbI6Iz
         2NGlzKf41Y3KXih5gzC8DrgmytJtLBR0fR+9COTV0cqxima/HDq0ZE3qezc6AxGLULxw
         QvVPEtWNTT6E+7IhOSfxk6Imz3Kwd9oquL4xZVegmg5J6RmKA+Q579C8zWhUZ0Xgx+wg
         Odu44f5qNxf0YGybb296DL6kiYL83GUZvAxTkNYx7/P7jh8Y7oHy08rWhL5bBJNZwAxg
         F49NHqKM5Ftnv8H4WdG/VQaSi+wlL4XQCGYc5hXr23N/QN1cDoWi2ATBLXK378abj8G0
         dyjw==
X-Gm-Message-State: AOAM531i+6Q7aynK3iiccNswCegr1OsQ+d7+kbZSb5vaFiPiiWA7Lg7z
        NCm30EqJ/V8JTMPqom7w25pk7pk3iA4=
X-Google-Smtp-Source: ABdhPJxx8SkwYvYT9fuqd8J8/D25/GRV4ipTe+x7gxZbCgpsQNDucApI5+ArqZrudVFBp8cYqIvrEUF3+SY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a05:6214:4c9:: with SMTP id
 ck9mr13433509qvb.52.1632531359011; Fri, 24 Sep 2021 17:55:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Sep 2021 17:55:27 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-14-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 13/14] KVM: x86: Directly block (instead of "halting")
 UNINITIALIZED vCPUs
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
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
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Go directly to kvm_vcpu_block() when handling the case where userspace
attempts to run an UNINITIALIZED vCPU.  The vCPU isn't halted and its time
spent in limbo arguably should not be factored into halt-polling as the
behavior of the VM at this point is not at all indicative of the behavior
of the VM once it is up and running, i.e. executing HLT in idle tasks.

Note, because this case is encountered only on the first run of an AP vCPU,
vcpu->halt_poll_ns is guaranteed to be '0', and so KVM will not attempt
halt-polling, i.e. this really only affects the post-block bookkeeping.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0d71c73a61bb..b444f9315766 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10127,7 +10127,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			r = -EINTR;
 			goto out;
 		}
-		kvm_vcpu_halt(vcpu);
+		kvm_vcpu_block(vcpu);
 		if (kvm_apic_accept_events(vcpu) < 0) {
 			r = 0;
 			goto out;
-- 
2.33.0.685.g46640cef36-goog

