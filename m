Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95718178A36
	for <lists+kvm-ppc@lfdr.de>; Wed,  4 Mar 2020 06:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgCDF3p (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 4 Mar 2020 00:29:45 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44384 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgCDF3p (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 4 Mar 2020 00:29:45 -0500
Received: by mail-pl1-f193.google.com with SMTP id d9so482361plo.11
        for <kvm-ppc@vger.kernel.org>; Tue, 03 Mar 2020 21:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d82Tno5gurUHP6iKVHQTX7MQWDM5UtD9FIcJLPTNinE=;
        b=Vq8aeIqtbkhjNiKxT1T1AD2Zo11ReVdw13ZYycCNqj5z8av3VzMfpvvcZuZ24Wn181
         xAKbD1Q5DijcL3QtdJG5L8aSAM4YXkGY+CHQlgM/dsiVJa23OvsGff1p5y6xh9OkhaA8
         9zrlyDJ8U/G+l3NL70guUjNQj8+EM1mmDkqDIKWnwf9dciPrnb0XeykESjpn8mneTgnc
         iZV2S+Q2+BEPp6HEcNHRk4+E599ODR8679IDRByAyAaFmRh5dj2lqMF97aYL9tjomsI7
         HHmIdoa42cnQKY5M3D/sI+Zk2U+sHGDY0V4QhNZKtIRWeyXZo0D/7AXGgAvVPw5JpXxI
         M+PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d82Tno5gurUHP6iKVHQTX7MQWDM5UtD9FIcJLPTNinE=;
        b=h/9KJ+f2u0gX1Niz6yKpru8XJge1iQh3GfAklBuL3pfh5ac6JGgNHITljenqEB9sE4
         6mJjNPMvBXYsejqc7JkMiPOBYeMxkN+TDWgypn/Ty69OmfJP/NanEQtSfnpJJ6GzJRDt
         6cdlarOuHQqGUgLA6My4qJXTDCm890USNO4wDsXLfKQWrpwX6qtCcSToA1UyN53+mAKg
         8TOrBqxj/HQqfa5iC3gJocakioLWbxQ8dZzP/d9RQpghPwnIwaaRT2Cm8DCBDITg/rx/
         UcKEOCCVh9aImCAqO7VJvYJZVjZzEwkSMtesWHoA1sqXP3laFTy6SXB+yHNqZahuRQDE
         +b7w==
X-Gm-Message-State: ANhLgQ1EPrCyygGTbMKL3DOz8GBzLhorlcd54nIAuAGq9KfJl7j5pwHY
        eMCAulGaOneqs4Nq3aF74pU=
X-Google-Smtp-Source: ADFU+vvCOVj3aCIgkWZtWLMma+Q1/ijy1Hv3AUIABrAIuV/a7U35tcR4DhLdTxlOtABcudbCKY7TrA==
X-Received: by 2002:a17:90a:32b0:: with SMTP id l45mr1261841pjb.180.1583299784489;
        Tue, 03 Mar 2020 21:29:44 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (193-116-117-248.tpgi.com.au. [193.116.117.248])
        by smtp.gmail.com with ESMTPSA id u1sm26502391pfn.133.2020.03.03.21.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 21:29:44 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     qemu-ppc@nongnu.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Aravinda Prasad <arawinda.p@gmail.com>,
        Ganesh Goudar <ganeshgr@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org
Subject: [RFC PATCH 13/13] ppc/spapr: KVM should not enable FWNMI until the guest requests it
Date:   Wed,  4 Mar 2020 15:28:50 +1000
Message-Id: <20200304052850.582373-14-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200304052850.582373-1-npiggin@gmail.com>
References: <20200304052850.582373-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

QEMU should not enable KVM FWNMI handling until the guest has requested
it. Although the QEMU NMI delivery will deliver interrupts as non-FWNMI,
KVM would like to know whether or not the guest is FWNMI capable because
in case of !FWNMI guests it may decide to take over some recovery tasks
(e.g., flush and reload SLB in case of a multi-hit) if the guest is not
FWNMI capable.

XXX: does this deal with machine resets properly, disabling it again on
the KVM side? Is synchronisation okay?

XXX: this is just an RFC, we could probably go either way here.
---
 hw/ppc/spapr_caps.c | 2 +-
 hw/ppc/spapr_rtas.c | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/hw/ppc/spapr_caps.c b/hw/ppc/spapr_caps.c
index f8583c6b44..c11db00109 100644
--- a/hw/ppc/spapr_caps.c
+++ b/hw/ppc/spapr_caps.c
@@ -517,7 +517,7 @@ static void cap_fwnmi_apply(SpaprMachineState *spapr, uint8_t val,
     }
 
     if (kvm_enabled()) {
-        if (kvmppc_set_fwnmi() < 0) {
+        if (!kvmppc_get_fwnmi()) {
             error_setg(errp, "Firmware Assisted Non-Maskable Interrupts(FWNMI) "
                              "not supported by KVM, "
                              "try appending -machine cap-fwnmi=off");
diff --git a/hw/ppc/spapr_rtas.c b/hw/ppc/spapr_rtas.c
index 6922a6b880..008a138d9b 100644
--- a/hw/ppc/spapr_rtas.c
+++ b/hw/ppc/spapr_rtas.c
@@ -437,6 +437,13 @@ static void rtas_ibm_nmi_register(PowerPCCPU *cpu,
         return;
     }
 
+    if (kvm_enabled()) {
+        if (kvmppc_set_fwnmi() < 0) {
+            rtas_st(rets, 0, RTAS_OUT_NOT_SUPPORTED);
+            return;
+        }
+    }
+
     spapr->fwnmi_system_reset_addr = sreset_addr;
     spapr->fwnmi_machine_check_addr = mce_addr;
 
-- 
2.23.0

