Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85AFF6793BA
	for <lists+kvm-ppc@lfdr.de>; Tue, 24 Jan 2023 10:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjAXJNE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 24 Jan 2023 04:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbjAXJND (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 24 Jan 2023 04:13:03 -0500
Received: from chowmein.spicy.dim-sum.org (chowmein.spicy.dim-sum.org [81.187.240.206])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB84F1A4A4
        for <kvm-ppc@vger.kernel.org>; Tue, 24 Jan 2023 01:12:57 -0800 (PST)
Received: from smtpclient.apple (e.a.6.6.1.0.f.a.a.5.a.e.4.6.0.d.4.1.0.0.9.9.f.f.0.b.8.0.1.0.0.2.ip6.arpa [IPv6:2001:8b0:ff99:14:d064:ea5a:af01:66ae])
        by chowmein.spicy.dim-sum.org (Postfix) with ESMTPS id 24B5CE0048D
        for <kvm-ppc@vger.kernel.org>; Tue, 24 Jan 2023 09:12:52 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dim-sum.org;
        s=chowmein; t=1674551573;
        bh=YXt7xOniepSs8g5kfFhYpLIPjkVxSdzS7kGdZolu4Pk=;
        h=From:Subject:Date:To:From;
        b=GpXV79jeYtjTAivUhj0bPSXyfokv7tOJIb9+15D5gqQu+NQVbIq+FJJuHoOPWtLNJ
         qv1YdZdwnlL3tbtob9rHSG3tuLDcKIkWDcLUxTawH/FbMISh5GfrHnnEYMbWk/mgAQ
         n7oz2C+VajJY1TKajo1i7X9dfTPtdbBZ1Z8K8np9DlWfK5cBokhCggG04kVtjrkjaN
         ykBFuh9h6B3XOsZM873+wQAQbW1ataVM0JsM3MNF8bRRewn7oo93iYSjayC2ItFwHU
         M4+15jPxbYZDa7bGr3c5FdEBC4y8HQKt7xyh4W+GZuyVXiso3yCQSaEvkueLXWETL6
         Ib0pHmGTBAwsA==
From:   Dan Whitehouse <drw@dim-sum.org>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Powermac G5 KVM Qemu
Message-Id: <5F435810-D601-47E3-A2C2-377CF9705215@dim-sum.org>
Date:   Tue, 24 Jan 2023 09:12:41 +0000
To:     kvm-ppc@vger.kernel.org
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi,
I have a Powermac G5 (dual core) running: Linux powermac-g5 =
6.0.0-6-powerpc64 #1 SMP Debian 6.0.12-1 (2022-12-09) ppc64, from Debian =
Ports.

I have been trying to get Qemu working with KVM for some time with no =
luck. Any attempt to do so causes my disk to thrash and I see:

[ 2718.262923] Couldn't emulate instruction 0x00000000 (op 0 xop 0)
[ 2718.274439] kvmppc_exit_pr_progint: emulation at 100 failed =
(00000000)

filling my dmesg.=20

This was briefly discussed in a thread titled "Re: [PATCH 2/9] =
target/ppc: add errp to kvmppc_read_int_cpu_dt()=E2=80=9D on the =
Qemu-PPC mailing list from July 6th of last year, but there doesn=E2=80=99=
t appear to have been much resolution.
It appears that KVM works on G4 processors on reasonably recent kernels: =
(Linux macmini 5.1.0-rc2+ #56 Wed Mar 27 00:38:43 GMT 2019 ppc =
GNU/Linux) and there is evidence from the Macrumors forum that it was =
working on G5 hardware back in the days of: Linux debian =
4.19.0-4-powerpc64 #1 SMP Debian 4.19.28-2 (2019-03-15) ppc64.

I=E2=80=99m not a developer so at this stage I=E2=80=99m uncertain =
whether the issue lies with Qemu or the Kernel, but any help with this =
would be appreciated.

Thanks,

Dan
