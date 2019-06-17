Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8452F47A95
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 Jun 2019 09:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbfFQHQ2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 17 Jun 2019 03:16:28 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41058 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfFQHQ2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 17 Jun 2019 03:16:28 -0400
Received: by mail-pl1-f195.google.com with SMTP id m7so113742pls.8
        for <kvm-ppc@vger.kernel.org>; Mon, 17 Jun 2019 00:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qcbh030EpOMi5S9ffPNcTh4Jaq49Rf+M0VqnYbSFotI=;
        b=D3bbfMWiGPFP7bKb5+lXDf0g1YLFwqfk8PqbcQrN3STXpU2WpewNplK/M2Kgn5Qpa+
         gVtYpBtwCgaegdD5DiqXB26Yyn4MTCpRSxzpMpsQfIGhqcbFMjxmxdBri4djXQa9Kr8b
         hTHsO5K3vHGCCSA6vjQzukgfDKJ4jXzcBYPyfsWDNjkBZCw+xppk/SO+01L6ka+o/N8D
         ZSOGwxfEnsN0OF9kbvXsDDc9G+PoRJ8Tdi9HeUfCYVO6yEMa009exubZGETLcN64d970
         H/N0iPeN50fqUQR26E2DNWDSYaD4lsgoUYfwnjsyvQI2xEM/9OOk3PL0odYaoXBypeuq
         SWGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qcbh030EpOMi5S9ffPNcTh4Jaq49Rf+M0VqnYbSFotI=;
        b=keKhe3C7I4XsVO8gJuNDfb+hAND1OZioJurGZxTWckmm2e9+MS91oSN9p6VbLTn5m9
         PnRhoqypEzFh0h/uPkjSDkWgncDbh0scecQRywH26SqfF33aXtyOw4FdStwqs9G0fuG6
         HDdX0mFVxXfZK9lM7bsWa8YbwZKrRtnrrjVH3kQm5BhlW6zYY1mCyOj1lOettwIF+NVm
         mP38Cz5XMqzDeAMhyEmpSQQwCfgoiiENXTwPCntIAinAZ4/XunUQHXWUHN8i6+3iH6J1
         kHODR+qBmWgQb8IxAk98Go2pVLpxUENP0R567kUAxm9axTwJJTK4u6fCYoxP03MuM62R
         iAfg==
X-Gm-Message-State: APjAAAUMoLCYhy5wSXBckBU9CEWnwnmRknaQiezsUzpC7si4xPuo4ldN
        pHEWZzWJQ/730+HZMzq7JE0=
X-Google-Smtp-Source: APXvYqy1muiVzF5vR7MeLAJXjHGDW90kpA+BwS/7WrjDullcpND0mic9zA3C0unIc6g0RVmB2DIr2g==
X-Received: by 2002:a17:902:934a:: with SMTP id g10mr96528682plp.18.1560755788095;
        Mon, 17 Jun 2019 00:16:28 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id m31sm22163663pjb.6.2019.06.17.00.16.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 17 Jun 2019 00:16:27 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mikey@neuling.org, mpe@ellerman.id.au,
        paulus@ozlabs.org, clg@kaod.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 0/2] Fix handling of h_set_dawr
Date:   Mon, 17 Jun 2019 17:16:17 +1000
Message-Id: <20190617071619.19360-1-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Series contains 2 patches to fix the host in kernel handling of the hcall
h_set_dawr.

First patch from Michael Neuling is just a resend added here for clarity.

Michael Neuling (1):
  KVM: PPC: Book3S HV: Fix r3 corruption in h_set_dabr()

Suraj Jitindar Singh (1):
  KVM: PPC: Book3S HV: Only write DAWR[X] when handling h_set_dawr in
    real mode

 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

-- 
2.13.6

