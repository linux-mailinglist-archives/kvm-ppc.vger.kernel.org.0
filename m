Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B217C4754
	for <lists+kvm-ppc@lfdr.de>; Wed,  2 Oct 2019 08:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfJBGBD (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 2 Oct 2019 02:01:03 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33000 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbfJBGBC (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 2 Oct 2019 02:01:02 -0400
Received: by mail-pl1-f193.google.com with SMTP id d22so6659030pls.0
        for <kvm-ppc@vger.kernel.org>; Tue, 01 Oct 2019 23:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4bJEH2pRIC7IajnRMF6AY/PY3WP86bRI3VEm9hDq78I=;
        b=O5FJm7yTZPqmzf9daVnRIHHBNLqQL0duB1PgG/6ZSkOooE0c6In+PXamZ06JqwTQEE
         ciiQShwW0DckXlqU8kRP8ImnP5kG5yWp0Z7JqutLwFtS16hYhas8mfqvJgD1J6C6E2E+
         na6sTkbt4zUERRjyZxJObYBUsNPYeTRd2t3sfbd1jcaHUiKEriluqZrhz5f5vyOgqWeh
         +XLLuKUxOuwfDr0MqbACOIREsQD+hiTSijEDfIUlfJVb8yiuzos2NMNM39dm9MRtxCOZ
         g+Hv1E/gLvqYXAdvBLWnmnZbmHHDLVoM7zeoOWe/dA9b0suZrmjuyWkLIBfn129VkYx/
         Vz/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4bJEH2pRIC7IajnRMF6AY/PY3WP86bRI3VEm9hDq78I=;
        b=pTBEJG7dSa8cW+C3RTroSOn7lU+nhkWMIgFzeJak4wLf63vb0iGAS8luHs7MbTk/i0
         SXLPM6mnbq2TNqhMxsGszZ38wP2OUl9sCH0IhCXfU8P458i2crpKUSDD74iDI2+j58Dn
         m2V/ly+trzQB7mVNJtKsbt8IwJlR1kmRmL03I1m8fe5i1eNRDJamp6TCTpE0S8M7lEMW
         ZSK+TtOhZZQhRJvyKMtyU0vZXq4CLABpqkR4CTiRRx4KOalWe/uyxrBDtXzSUcqM0OeE
         XQbuI4Z1D7YljrND/UDz0YijmJy2q/wz9MfNYEmaXo4nRDtL1cI6qfa+GHKKqGe5/DkY
         JH1w==
X-Gm-Message-State: APjAAAVpFgBu3z2EZRDjtrPArkkrvaAiPpY2zKCziMCf89Quhd3d4hYf
        EGdhL6ONjvWf8ibw3C04nWS7hpWm
X-Google-Smtp-Source: APXvYqwdr0a++XTul7n2gTpP+MXNmrwIclo8rotO+XmbQZ3RlU/HesC0NPWAamQW4cSw7GMEy8sOuA==
X-Received: by 2002:a17:902:8a82:: with SMTP id p2mr1862112plo.112.1569996061624;
        Tue, 01 Oct 2019 23:01:01 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id v12sm18660749pgr.31.2019.10.01.23.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 23:01:01 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v2 5/5] KVM: PPC: Book3S HV: Reject mflags=2 (LPCR[AIL]=2) ADDR_TRANS_MODE mode
Date:   Wed,  2 Oct 2019 16:00:25 +1000
Message-Id: <20191002060025.11644-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002060025.11644-1-npiggin@gmail.com>
References: <20191002060025.11644-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

AIL=2 mode has no known users, so is not well tested or supported.
Disallow guests from selecting this mode because it may become
deprecated in future versions of the architecture.

This policy decision is not left to QEMU because KVM support is
required for AIL=2 (when injecting interrupts).

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index c340d416dce3..ec5c0379296a 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -779,6 +779,11 @@ static int kvmppc_h_set_mode(struct kvm_vcpu *vcpu, unsigned long mflags,
 		vcpu->arch.dawr  = value1;
 		vcpu->arch.dawrx = value2;
 		return H_SUCCESS;
+	case H_SET_MODE_RESOURCE_ADDR_TRANS_MODE:
+		/* KVM does not support mflags=2 (AIL=2) */
+		if (mflags != 0 && mflags != 3)
+			return H_UNSUPPORTED_FLAG_START;
+		return H_TOO_HARD;
 	default:
 		return H_TOO_HARD;
 	}
-- 
2.23.0

