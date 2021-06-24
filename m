Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BA03B25CB
	for <lists+kvm-ppc@lfdr.de>; Thu, 24 Jun 2021 05:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbhFXEBo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 24 Jun 2021 00:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhFXEBn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 24 Jun 2021 00:01:43 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73088C061756
        for <kvm-ppc@vger.kernel.org>; Wed, 23 Jun 2021 20:59:24 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id y13so2249431plc.8
        for <kvm-ppc@vger.kernel.org>; Wed, 23 Jun 2021 20:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y2W7T6qLTS3Ag7NuAuUIEAg67sPyiesCNMUj+p56BzY=;
        b=g8nSjjfxIBXk4iRyM4lDbfJzcUO123uZjh0RON0fXQwb8kyWdvJ99YtzcNsJdcW79w
         BLdPz3Bosh+WypVWcDrteNvejBUGZqV7Gjr/9gfUWwY5ZNBNimDbH5JiJYT2XnLubHCB
         FZKukRJWUrijD93ZogN/F8+SkBe8RkjXiOk2Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y2W7T6qLTS3Ag7NuAuUIEAg67sPyiesCNMUj+p56BzY=;
        b=GyUMqV425cV6xqYrc9bkfcS/mnSxXx3OqeH/cAU/oWl8PqbS/5Oh8M8d5msexU99iF
         nJ4QLuTI9DNDq2soWH0z0wh/7GyrAhgfJjAWaDFPn9DqxtxSYK8coE9ei2TsFLn9YE5M
         MHFVJ1Ondu1qwUPFxIjDIdG0vjDWhB7eSUsMUoALsl/nhzubWz8oJlarSU5caw7LEerd
         AaHGK4SHDGkg+VNF+wh5JTA1eec3y3JSbr3bq9nLEu3IXm3fFNRPNls+WqsZiAiowCxT
         6jRZuCTMHuGh+ey4UXM5gIIIdIsojLuKbxxSXXXhroqabVW4p0IcMO3DPuKz2VRc/nSk
         J5VA==
X-Gm-Message-State: AOAM5331fG6f24MiYRNcEFfXrPZMctQ6n/iSnPqOiiQegpUJqYHqr+hm
        teSGOTfxfanRZKWsunlSSyEnuA==
X-Google-Smtp-Source: ABdhPJwqCB154PR6k9RDOGQgmS7bfDVXTfHVxk5gZuq7k0BJad439o4c4+nm6Z45Q9WJ95xxqXqGDA==
X-Received: by 2002:a17:902:b188:b029:11b:1549:da31 with SMTP id s8-20020a170902b188b029011b1549da31mr2405367plr.7.1624507164071;
        Wed, 23 Jun 2021 20:59:24 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:5038:6344:7f10:3690])
        by smtp.gmail.com with UTF8SMTPSA id f205sm1163119pfa.154.2021.06.23.20.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 20:59:23 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH 1/6] KVM: x86/mmu: release audited pfns
Date:   Thu, 24 Jun 2021 12:57:44 +0900
Message-Id: <20210624035749.4054934-2-stevensd@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
In-Reply-To: <20210624035749.4054934-1-stevensd@google.com>
References: <20210624035749.4054934-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/x86/kvm/mmu/mmu_audit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
index cedc17b2f60e..97ff184084b4 100644
--- a/arch/x86/kvm/mmu/mmu_audit.c
+++ b/arch/x86/kvm/mmu/mmu_audit.c
@@ -121,6 +121,8 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 		audit_printk(vcpu->kvm, "levels %d pfn %llx hpa %llx "
 			     "ent %llxn", vcpu->arch.mmu->root_level, pfn,
 			     hpa, *sptep);
+
+	kvm_release_pfn_clean(pfn);
 }
 
 static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
-- 
2.32.0.93.g670b81a890-goog

