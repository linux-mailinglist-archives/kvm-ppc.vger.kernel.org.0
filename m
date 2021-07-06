Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D17C3BDCA8
	for <lists+kvm-ppc@lfdr.de>; Tue,  6 Jul 2021 20:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhGFSGi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 6 Jul 2021 14:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbhGFSGh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 6 Jul 2021 14:06:37 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D63C061574
        for <kvm-ppc@vger.kernel.org>; Tue,  6 Jul 2021 11:03:59 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id ke6-20020a0562143006b029028b8546bb01so13760246qvb.20
        for <kvm-ppc@vger.kernel.org>; Tue, 06 Jul 2021 11:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gxtUTPh5fwor/wpaYj5ONrHNzCoa+ClILdYbD39HBRk=;
        b=wN4RzJjIy66SQWY9ue61jGTFPH+UVIiQNgDal1a8vHwCpqS5QhIFL6/KOZw8s/mZ+4
         nIU6410/kFLTkuDPLsCjIRSOR40hebTNN62avpmP1QsZmdFRMPABE9g4aXZMYpG7Mjir
         QmNC/Qq8YLPDvOTHbJipU9T/E90TerxsSsLReQS8h1T2V+xVpgnSYsDQezkUFEqqelpn
         7F+rh5SfNFjCiU9Y7Z7Cx5Q+QClJR8YEtHcBI7iwOkA+YLG60ubwdMr83toSoTKlfqnV
         yFjNZ16Rco0U6CmIHwGUQrTJr8wmbJsf5d8ujQcMOsHDimLexKA8i4GqjDJ0RbRHDORw
         keFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gxtUTPh5fwor/wpaYj5ONrHNzCoa+ClILdYbD39HBRk=;
        b=o/6lDLMSKsl9ownhGG2xTbE+xSVnK3VokVqgC/UV15cgl3O6kVrR+3qTxN5by6VXS/
         3xHMpvZCRAoIISFi5yIC7y4vO5jLZJGz0WkcnoCugU8RBl8q+eS0t15taOeHxHaSF2a1
         BaxkOU849s1OnX8Ccgs0u7Eb2d9Ai+Lmz66/e8pnvN444j10tu+prLI8cYgtUUzaentN
         VYtTxR8QgEODWHDl1GbcrplzTkfBLlGDNihzksB+g8XxOQxnoQGxRU0YcNPqLT2h+3V7
         LByQOugBmoCFpwFsmW9+SLuU6b37BOYt3TuInyWYJWXgVevmMJ5G+hKHkopQTogokwUa
         +8Pg==
X-Gm-Message-State: AOAM5315vDbcQckxvRSMSIst7fc+u0OsQQG3iGRGca8q961FS0EtF00x
        ouY69WTHfK5EouPIrChn2B08NHngmiUhfk5EZg==
X-Google-Smtp-Source: ABdhPJzVXrdypAr1xE54GQA/Ctgc3cZntz0ffeuVpUUBIt4PA3RZaVP6zuES/rRdA1przzfP6bV3RnYDCO/yZR6vxw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6214:1042:: with SMTP id
 l2mr19298254qvr.53.1625594638130; Tue, 06 Jul 2021 11:03:58 -0700 (PDT)
Date:   Tue,  6 Jul 2021 18:03:49 +0000
In-Reply-To: <20210706180350.2838127-1-jingzhangos@google.com>
Message-Id: <20210706180350.2838127-4-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210706180350.2838127-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v1 3/4] KVM: selftests: Add checks for histogram stats parameters
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The hist_param field should be zero for simple stats and 2 for
logarithmic histogram. It shouldbe non-zero for linear histogram stats.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 .../selftests/kvm/kvm_binary_stats_test.c       | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 5906bbc08483..03c7842fcb26 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -109,6 +109,23 @@ static void stats_test(int stats_fd)
 		/* Check size field, which should not be zero */
 		TEST_ASSERT(pdesc->size, "KVM descriptor(%s) with size of 0",
 				pdesc->name);
+		/* Check hist_param field */
+		switch (pdesc->flags & KVM_STATS_TYPE_MASK) {
+		case KVM_STATS_TYPE_LINEAR_HIST:
+			TEST_ASSERT(pdesc->hist_param,
+			    "Bucket size of Linear Histogram stats (%s) is zero",
+			    pdesc->name);
+			break;
+		case KVM_STATS_TYPE_LOG_HIST:
+			TEST_ASSERT(pdesc->hist_param == 2,
+				"Base of Log Histogram stats (%s) is not 2",
+				pdesc->name);
+			break;
+		default:
+			TEST_ASSERT(!pdesc->hist_param,
+			    "Simple stats (%s) with hist_param of nonzero",
+			    pdesc->name);
+		}
 		size_data += pdesc->size * sizeof(*stats_data);
 	}
 	/* Check overlap */
-- 
2.32.0.93.g670b81a890-goog

