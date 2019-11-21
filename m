Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C67F1049C1
	for <lists+kvm-ppc@lfdr.de>; Thu, 21 Nov 2019 05:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfKUE5y (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 20 Nov 2019 23:57:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51579 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725854AbfKUE5y (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 20 Nov 2019 23:57:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574312273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yv0X/nVIYvnkcCQB7VwrmBY+75939CQRr75Nan6lnI4=;
        b=Yfi/qSzxJIkQbnyomcNd5XWfpZ1r084OyXkh3nyML2bK7RgmYpLhFSS0mDxF9mZv77j0tS
        q3kAvURWYAEchKkrfzm0yGEjGPpst+odpdrL+CnrL4VHP/OS/jCcftOQSNTywMVGSW0jAn
        xRRpd3njJEK8JiWofXVv4aQmx9u0ROo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-_IeSMIl9PlW7GFhP47eI9Q-1; Wed, 20 Nov 2019 23:57:11 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C51D1005509;
        Thu, 21 Nov 2019 04:57:10 +0000 (UTC)
Received: from kaapi (unknown [10.74.10.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A06A360BF7;
        Thu, 21 Nov 2019 04:57:08 +0000 (UTC)
Date:   Thu, 21 Nov 2019 10:27:04 +0530 (IST)
From:   P J P <ppandit@redhat.com>
X-X-Sender: pjp@kaapi
To:     Paul Mackerras <paulus@ozlabs.org>
cc:     kvm-ppc@vger.kernel.org, Reno Robert <renorobert@gmail.com>
Subject: Re: [PATCH v2] kvm: mpic: limit active IRQ sources to NUM_OUTPUTS
In-Reply-To: <20191120214119.GA12722@blackberry>
Message-ID: <nycvar.YSQ.7.76.1911211023470.11913@xnncv>
References: <20191115050620.21360-1-ppandit@redhat.com> <20191120023334.GA24617@oak.ozlabs.ibm.com> <nycvar.YSQ.7.76.1911201625080.24911@xnncv> <20191120214119.GA12722@blackberry>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: _IeSMIl9PlW7GFhP47eI9Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

  Hello Paul,

+-- On Thu, 21 Nov 2019, Paul Mackerras wrote --+
| > It does not seem to set it to 0x3. When a no is divisible by 0x3,=20
| > 'src->output' will be set to zero(0).
|=20
| You're right, I misread the '%' as '&'.

Considering E500 is mostly used for SoC/Embedded systems. It is not clear i=
f=20
this issue can be misused from a guest running on PPC E500 platform.

...wdyt?
--
Prasad J Pandit / Red Hat Product Security Team
8685 545E B54C 486B C6EB 271E E285 8B5A F050 DE8D

