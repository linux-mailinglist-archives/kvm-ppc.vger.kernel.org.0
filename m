Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 342F7FB608
	for <lists+kvm-ppc@lfdr.de>; Wed, 13 Nov 2019 18:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfKMROT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 13 Nov 2019 12:14:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41936 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726115AbfKMROT (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 13 Nov 2019 12:14:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573665258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=zhcr8sNl0s2v8uxJbO+Uz+hCh9MxWoYyED6dGzbOw1w=;
        b=EcKeLq6eKFskvtReTS0egrsDJsIjz0GaUJbsdeJQ9TJbzKk+XQx8AnxwG7eVLVysSpx9Kf
        5QLwg06xhiUvrac7pPTQv1To1ajKsuWfbOSGuhdeBywwwIQJGyKsivYVr+7EhHQjhiSI+R
        QXYyu5L1RbEhEoNSREA7r/XwziM28AY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-vkQbVPXZPZOkKTJJrntAvg-1; Wed, 13 Nov 2019 12:14:17 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E798D184CC18;
        Wed, 13 Nov 2019 17:14:15 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.74.10.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1823A5F761;
        Wed, 13 Nov 2019 17:14:12 +0000 (UTC)
From:   P J P <ppandit@redhat.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Reno Robert <renorobert@gmail.com>,
        P J P <pjp@fedoraproject.org>
Subject: [PATCH] kvm: mpic: extend active IRQ sources to 255
Date:   Wed, 13 Nov 2019 22:42:08 +0530
Message-Id: <20191113171208.8509-1-ppandit@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: vkQbVPXZPZOkKTJJrntAvg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: P J P <pjp@fedoraproject.org>

openpic_src_write sets interrupt level 'src->output' masked with
ILR_INTTGT_MASK(=3D0xFF). It's then used to index 'dst->outputs_active'
array. With NUM_INPUTS=3D3, it may lead to OOB array access.

Reported-by: Reno Robert <renorobert@gmail.com>
Signed-off-by: P J P <pjp@fedoraproject.org>
---
 arch/powerpc/kvm/mpic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/mpic.c b/arch/powerpc/kvm/mpic.c
index fe312c160d97..a5ae884d3891 100644
--- a/arch/powerpc/kvm/mpic.c
+++ b/arch/powerpc/kvm/mpic.c
@@ -103,7 +103,7 @@ static struct fsl_mpic_info fsl_mpic_42 =3D {
 #define ILR_INTTGT_INT    0x00
 #define ILR_INTTGT_CINT   0x01=09/* critical */
 #define ILR_INTTGT_MCP    0x02=09/* machine check */
-#define NUM_OUTPUTS       3
+#define NUM_OUTPUTS       0xff
=20
 #define MSIIR_OFFSET       0x140
 #define MSIIR_SRS_SHIFT    29
--=20
2.21.0

