Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2692FD5F1
	for <lists+kvm-ppc@lfdr.de>; Fri, 15 Nov 2019 07:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfKOGSH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 15 Nov 2019 01:18:07 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41022 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726182AbfKOGSH (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 15 Nov 2019 01:18:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573798686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=siUQ+hDE+uiTqiKhxTSvSIYqcFCp2Rr4I1YvD3W+GkU=;
        b=T9k9BlbMIAAYdlc3e87grERaSuCXZ+3B0Q8+CkWALDbn6FaxM7AWPqKZpxwCz7AkBw+3vW
        G7sn/LcwY7/gvih6n257p0AOBKmc+JNWG93s0TqdoB5IPU5p5g0xadkQDOdxxor4pgZa3p
        j4H1yv/W5BfkdYl0W092CNINEZ6P0as=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-ZLQ177l-P_-2RrZuhmLppg-1; Fri, 15 Nov 2019 01:18:05 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE3EF477;
        Fri, 15 Nov 2019 06:18:03 +0000 (UTC)
Received: from kaapi (ovpn-116-167.sin2.redhat.com [10.67.116.167])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 090271001281;
        Fri, 15 Nov 2019 06:18:01 +0000 (UTC)
Date:   Fri, 15 Nov 2019 11:47:56 +0530 (IST)
From:   P J P <ppandit@redhat.com>
X-X-Sender: pjp@kaapi
To:     Paul Mackerras <paulus@ozlabs.org>
cc:     kvm-ppc@vger.kernel.org, Reno Robert <renorobert@gmail.com>
Subject: Re: [PATCH] kvm: mpic: extend active IRQ sources to 255
In-Reply-To: <20191114235349.GA1393@oak.ozlabs.ibm.com>
Message-ID: <nycvar.YSQ.7.76.1911151141130.24911@xnncv>
References: <20191113171208.8509-1-ppandit@redhat.com> <20191114235349.GA1393@oak.ozlabs.ibm.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: ZLQ177l-P_-2RrZuhmLppg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

  Hello Paul,

+-- On Fri, 15 Nov 2019, Paul Mackerras wrote --+
| Instead we need either to prevent src->output from being set to 3 or=20
| greater, or else limit its value when it is used.

I've sent a revised patch v2 for this.

It is not clear if this issue can be misused from a guest running on PPC E5=
00=20
platform. Considering E500 is mostly used for SoC/Embedded systems.

...wdyt?
--
Prasad J Pandit / Red Hat Product Security Team
8685 545E B54C 486B C6EB 271E E285 8B5A F050 DE8D

