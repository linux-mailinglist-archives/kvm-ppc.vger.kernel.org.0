Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324AB3F9AEA
	for <lists+kvm-ppc@lfdr.de>; Fri, 27 Aug 2021 16:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhH0Ogb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 27 Aug 2021 10:36:31 -0400
Received: from mail-0301.mail-europe.com ([188.165.51.139]:39910 "EHLO
        mail-0301.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbhH0Ogb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 27 Aug 2021 10:36:31 -0400
Date:   Fri, 27 Aug 2021 14:35:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1630074939;
        bh=OJRN8Z54/IeUVqiL5Gc5qsF5PbVHWHsn8rcOB/97h00=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=tCKcQJUlCySO5tBvfh3FJ3rdGB0Eswx7TFsl8/jcJQZ4JyWvgauQddhdZxRth6804
         9KsJ+3k8bbEK/UPo7tG+v2gzWwdWLqeXQKbdqDiYJtH+swNEwEcU/ks6we0DEEFdBL
         oi718XqPSY4Cg+b/BL5kkaD75OqxXhCtdnp85Jcs=
To:     "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>
From:   Joseph <joseph.mayer@protonmail.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>, Karel Gardas <gardask@gmail.com>,
        "Peter J. Philipp" <pjp@centroid.eu>,
        Mark Kettenis <mark.kettenis@xs4all.nl>,
        "kite@centroid.eu" <kite@centroid.eu>, rgc <rgcinjp@disroot.org>,
        Alan Gifford <siliconbadger@protonmail.com>,
        Daniel Pocock <daniel@pocock.pro>
Reply-To: Joseph <joseph.mayer@protonmail.com>
Subject: QEMU-KVM offers OPAL firmware interface? OpenBSD guest support?
Message-ID: <i9sauevIbXa6g3UvMfA7JQxafMUIrM0KiRmkCWoHi2wVjB0uIAYIXB1fBlxmFOPmocUhwHGbJBkBcBvrTEok-kToxrn8lq_35TgGIEOh5lc=@protonmail.com>
In-Reply-To: <7r8MLHEKQicVkfT4tQLsiRXQmt_800XbV1s0mM_QJTgOY7XadpiRcD4HizmXByPaZRsMQV2WbNKDfKU-PdVo3ZO9JC6fJ0MF5LM_j5a2fgA=@protonmail.com>
References: <7r8MLHEKQicVkfT4tQLsiRXQmt_800XbV1s0mM_QJTgOY7XadpiRcD4HizmXByPaZRsMQV2WbNKDfKU-PdVo3ZO9JC6fJ0MF5LM_j5a2fgA=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi KVM-PPC emailing list,

I just emailed this to QEMU-PPC, and then realized it should probably
go here too. Any cues much appreciated.

 --

Hi QEMU PPC emailing list!

(And maintainers https://wiki.qemu.org/Documentation/Platforms/POWER )

https://www.openbsd.org/powerpc64.html says "OpenBSD/powerpc64 does
not run under a hypervisor such as PowerVM or PowerKVM".

QEMU-KVM is not listed here but I have heard no success report
anywhere, so I presume it doesn't work.

From talking to people, I gather that the limit to running OpenBSD
as VM guest on POWER, is that it operates based on the OPAL firmware
interface, and for some reason previous VM:s did not export it. But
also, I may have gotten this detail wrong.
(https://www.talospace.com/2020/07/when-will-openpower-openbsd-be-now-now.h=
tml)

Watching the POWER QEMU Wiki page https://wiki.qemu.org/Documentation/Platf=
orms/POWER
I don't see any mentioning of any of this .

Can you who work with QEMU POWER support help clarify, can OpenBSD
run as a QEMU-KVM guest - if so what are the steps to get it going -
and or are any updates to QEMU coming that will enable it?

Any cues much appreciated.

I brought up this same question on the OpenBSD PPC emailing list,
https://marc.info/?l=3Dopenbsd-ppc&m=3D163006851125546&w=3D2 , waiting for
response.

Thanks!
Joseph
