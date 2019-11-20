Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6D9103820
	for <lists+kvm-ppc@lfdr.de>; Wed, 20 Nov 2019 12:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfKTLAn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 20 Nov 2019 06:00:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52188 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727374AbfKTLAn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 20 Nov 2019 06:00:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574247642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yqd21YPYlShxz6RSx/O8mlm3Xu39muv5Mt4KbMnONoo=;
        b=C1UgX8y0YwnGQBUiefEedCWk9WP2hWiEsqdFl7kPu9k68gbFItEUBgmF+pdBJAyxrLldFY
        LO38Y7lZhkir97sxtU4fVazkJ7OvkQ85FKztlKoFGFtZTDDDCoPoYuvOsiR7pqWQYFdm7u
        JN5BR9VCabtWGd2m9vJMPsMyzllf7iQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-A8ZBIe1KNq2A-xoYOXLFCQ-1; Wed, 20 Nov 2019 06:00:38 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EAE680268D;
        Wed, 20 Nov 2019 11:00:37 +0000 (UTC)
Received: from kaapi (unknown [10.74.10.74])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 07C841037ACE;
        Wed, 20 Nov 2019 11:00:35 +0000 (UTC)
Date:   Wed, 20 Nov 2019 16:30:32 +0530 (IST)
From:   P J P <ppandit@redhat.com>
X-X-Sender: pjp@kaapi
To:     Paul Mackerras <paulus@ozlabs.org>
cc:     kvm-ppc@vger.kernel.org, Reno Robert <renorobert@gmail.com>
Subject: Re: [PATCH v2] kvm: mpic: limit active IRQ sources to NUM_OUTPUTS
In-Reply-To: <20191120023334.GA24617@oak.ozlabs.ibm.com>
Message-ID: <nycvar.YSQ.7.76.1911201625080.24911@xnncv>
References: <20191115050620.21360-1-ppandit@redhat.com> <20191120023334.GA24617@oak.ozlabs.ibm.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: A8ZBIe1KNq2A-xoYOXLFCQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

+-- On Wed, 20 Nov 2019, Paul Mackerras wrote --+
| Still not right, I'm afraid, since it could leave src->output set to
| 3, which would lead to an out-of-bounds array access.  I think it
| needs to be

=3D=3D=3D
#include <stdio.h>

int
main (int argc, char *argv[])
{  =20
    int i =3D 0;

    for (i =3D 0; i < 1024; i++) {
        printf ("%d: %d\n", i, i % 0x3);
    }

    return 0;
}

-> https://paste.centos.org/view/fb14b3cf
=3D=3D=3D

It does not seem to set it to 0x3. When a no is divisible by 0x3,=20
'src->output' will be set to zero(0).

Thank you.
--
Prasad J Pandit / Red Hat Product Security Team
8685 545E B54C 486B C6EB 271E E285 8B5A F050 DE8D

