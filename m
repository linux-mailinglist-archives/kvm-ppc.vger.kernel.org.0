Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F01FD3EE
	for <lists+kvm-ppc@lfdr.de>; Fri, 15 Nov 2019 06:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfKOFIc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 15 Nov 2019 00:08:32 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25262 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725773AbfKOFIb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 15 Nov 2019 00:08:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573794510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=U8iBsaIxSsj0ZoO4S8qvIeBfnCWgOhiUmVUcgjWjQtQ=;
        b=gzk0uxH2I2DN4x1B35bqy6K4G3quHmoVVJk45pGBX3O5O0CRKKAS3MtfTmvD8MM9I84JGF
        cvmvY1ztrRXc5e7V1fsEPZodqAO7HZsOTkNyPeWfVyQonug5KSrqvieLCIBry39+2XH0tu
        0kqN2EmTipvsJHIRuqRgkAbu+BzUtns=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-ofsCYK-5MOCcfv5EEJOozA-1; Fri, 15 Nov 2019 00:08:27 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5463C1005511;
        Fri, 15 Nov 2019 05:08:26 +0000 (UTC)
Received: from localhost.localdomain (ovpn-120-115.rdu2.redhat.com [10.10.120.115])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 278DC19067;
        Fri, 15 Nov 2019 05:08:23 +0000 (UTC)
From:   P J P <ppandit@redhat.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org, Reno Robert <renorobert@gmail.com>,
        P J P <pjp@fedoraproject.org>
Subject: [PATCH v2] kvm: mpic: limit active IRQ sources to NUM_OUTPUTS
Date:   Fri, 15 Nov 2019 10:36:20 +0530
Message-Id: <20191115050620.21360-1-ppandit@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: ofsCYK-5MOCcfv5EEJOozA-1
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
array. With NUM_OUTPUTS=3D3, it may lead to OOB array access. Limit
active IRQ sources to < NUM_OUTPUTS.

Reported-by: Reno Robert <renorobert@gmail.com>
Signed-off-by: P J P <pjp@fedoraproject.org>
---
 arch/powerpc/kvm/mpic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Update v2: limit IRQ sources to NUM_OUTPUTS
  -> https://www.spinics.net/lists/kvm-ppc/msg16554.html

diff --git a/arch/powerpc/kvm/mpic.c b/arch/powerpc/kvm/mpic.c
index fe312c160d97..fe4afd54c6e7 100644
--- a/arch/powerpc/kvm/mpic.c
+++ b/arch/powerpc/kvm/mpic.c
@@ -628,7 +628,7 @@ static inline void write_IRQreg_ilr(struct openpic *opp=
, int n_IRQ,
 =09if (opp->flags & OPENPIC_FLAG_ILR) {
 =09=09struct irq_source *src =3D &opp->src[n_IRQ];

-=09=09src->output =3D val & ILR_INTTGT_MASK;
+=09=09src->output =3D val % NUM_OUTPUTS;
 =09=09pr_debug("Set ILR %d to 0x%08x, output %d\n", n_IRQ, src->idr,
 =09=09=09src->output);

--
2.21.0

