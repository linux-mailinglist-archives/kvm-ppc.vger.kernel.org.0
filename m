Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36606229A0
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 May 2019 02:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbfETA6D (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 19 May 2019 20:58:03 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33714 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727866AbfETA6D (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 19 May 2019 20:58:03 -0400
Received: by mail-pl1-f194.google.com with SMTP id y3so5904097plp.0
        for <kvm-ppc@vger.kernel.org>; Sun, 19 May 2019 17:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i64xjSslx12S+qoH2537cK0m77t7O1b/Nt/NA672pFU=;
        b=ej5SJh1p0ZbjKy8yqB5pJqasdRxiFItl2Wqr/vlFs09OHeSKu28KFEDM0dvnS9Yp1/
         sylrhC5hstKTnYbuiGzkThDJU+z84VnGBClGt98gXVlnzaNS09cWMFz1JEnqaqYkQehd
         yToyQTL1K51vw9VL2LtmfK83OhQOSEOuit2btPHGq11I6U5WVL0E7kxJz9sd2/Ct1dO3
         UV00S397de1PBH7WZlgysitVeRvycljdOfqeg/W2oabHWQt4AiYF0BgLxF9JGVrshiMa
         xxwGhOdVpJK6ITKdcYFMIGuQTSMUWPdnZ4CsR9MqAzcTK5dZT0g+C/m/aTdyTnzl9FSs
         tcKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i64xjSslx12S+qoH2537cK0m77t7O1b/Nt/NA672pFU=;
        b=Ma3wDKFTVbNF0uq+Vc7V/IUbQheQIYY/ZTrHwwFwKqspbomXAmvh931UuqetI+Ktp0
         UWo2YC0Kv+7NmyhLPQutFQEXWU3T+R8zSb0T0yq6fQ5O8M+sekP3fBeCENwb4bje0Cm+
         FtkcGlRKFDUHszvWORntGOdNnQva6qBckyJ7pjci5TB+SohsAtYy9O9K7o8MUqvV4SOM
         7M/MX/48xr9XrP4sC8UULpCFUIyl6Ip20LLH1FyRTEdSWSW8q1kI54ntP+3cgAxIyg/o
         YIO8wWojy14SiEi9T46y5FWvHP1pM/mGWkKYMUupWXoKLGJgWbrisyord5kLEvFf9vip
         RuBw==
X-Gm-Message-State: APjAAAVjSMTlk5sQXkpUrMog53YyC05RlZ1c13C+vaXm0g3NOe9vTbaG
        vyYdCYsRrXGRaccvoD9htoUhQHMLsjs=
X-Google-Smtp-Source: APXvYqxk/EZBaCwXNKEUrhs6Pxb3VNDSrlu/wXYDpsYIge+EwXlay60tfUMzbQ3DxTDV7354UqliZQ==
X-Received: by 2002:a17:902:a515:: with SMTP id s21mr48618275plq.153.1558313883099;
        Sun, 19 May 2019 17:58:03 -0700 (PDT)
Received: from bobo.local0.net (193-116-79-244.tpgi.com.au. [193.116.79.244])
        by smtp.gmail.com with ESMTPSA id q193sm22643371pfc.52.2019.05.19.17.58.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 May 2019 17:58:02 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH 5/5] KVM: PPC: Book3S HV: Reject mflags=2 (LPCR[AIL]=2) ADDR_TRANS_MODE mode
Date:   Mon, 20 May 2019 10:56:59 +1000
Message-Id: <20190520005659.18628-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190520005659.18628-1-npiggin@gmail.com>
References: <20190520005659.18628-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

AIL=2 mode has no known users, so is not well tested or supported.
Disallow guests from selecting this mode because it may become
deprecated in future versions of the architecture.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 36d16740748a..4295ccdbee26 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -784,6 +784,11 @@ static int kvmppc_h_set_mode(struct kvm_vcpu *vcpu, unsigned long mflags,
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
2.20.1

