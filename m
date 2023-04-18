Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E576E58C6
	for <lists+kvm-ppc@lfdr.de>; Tue, 18 Apr 2023 07:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjDRFvA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 18 Apr 2023 01:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbjDRFu7 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 18 Apr 2023 01:50:59 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE94C46A0
        for <kvm-ppc@vger.kernel.org>; Mon, 17 Apr 2023 22:50:57 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id l13so3904927uan.10
        for <kvm-ppc@vger.kernel.org>; Mon, 17 Apr 2023 22:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681797057; x=1684389057;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dQlu0Oc2Q0nPMBCNq5iTPUZpwrRZlsMdPt2zjra8+VI=;
        b=mAQsEI+ar0sTy4Q5+pMCfiviCPnXnULP6NKgSBnA/WWEKNZht+o60DWll2REV2vz9C
         uP81SkoqwATmQagceVowqRtw3CHzU3OPq7T/fd3pVI19DIHs44gK+9Qxlut2Ii+422wY
         hoNvCSE2++DJiPJ0W6A5/DXe6ztipAA35KTtaYzkv5SfjaJ4PjJYcCiRZWwDvg7YzgHi
         9ItIC/htlNM0oUvHZgV7X36Mdc7+9geMLf9QTK768nJ34o1+v7l5WCLxVyw/lR3LJFzH
         zo31XEaHPe3XOFx7mD+TVBSysfnPyRz2cJ89kIkYreGzVe0h8TqCSszd99QzHdW26HuC
         uupg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681797057; x=1684389057;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dQlu0Oc2Q0nPMBCNq5iTPUZpwrRZlsMdPt2zjra8+VI=;
        b=jyMmUin5RnvUpPZB6Z33vZgaDgpGq6bxz8bqKsQPbPP1n3mIBU05NrVq3X+UdR0F+5
         qCV/8qnW8zxc/AgngckXENp5KdoTw3GHwpTYHlas7qZ2bEJNLF0qEmnCwvhafc6GCuPt
         P2ElgiZw/PB55bAS0PXLxzp1h9zATt+YixvsueF8a/U/pnf1qflnaNByOFrbcSoNpoEt
         b+Zw+GM4HXpI75lgQQ9LIyc/PO+bDT9rsiPLRxMOPqdd0Akv55MRG21U6eNg4E4bARjn
         nNkHmGdeWnslXxbjSkUL4FOW2R+DIvbnPk5B9eiKOIhJyrq18sxcdB0A/Pq5b0Vr9u9H
         Kl3Q==
X-Gm-Message-State: AAQBX9f63u6pnck2NApzrl0yBkRm4dlHudWICJ/oG7buNwvUrsYjokHs
        E3CNmSAQTN5cbstDg0bmEasNXnRxqTXDc9QtO7A=
X-Google-Smtp-Source: AKy350ZqPaL401l0ATV5mOBflVWVOePy1MdIb3n5KMdvc0a++0YC6xgNHMWobTudMZGn72euP54KdqUnffCw84riQq8=
X-Received: by 2002:a1f:bd4b:0:b0:439:bd5c:630 with SMTP id
 n72-20020a1fbd4b000000b00439bd5c0630mr4972960vkf.6.1681797056721; Mon, 17 Apr
 2023 22:50:56 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:dc45:0:b0:3c4:936f:80ba with HTTP; Mon, 17 Apr 2023
 22:50:56 -0700 (PDT)
Reply-To: mariamkouame01@hotmail.com
From:   Mariam Kouame <mariamkouame1991@gmail.com>
Date:   Mon, 17 Apr 2023 22:50:56 -0700
Message-ID: <CAGjw6zA-zUbK8ZvE2GYHU6Vtn44aQawzc9iPK7ZXmZ+Uw5Qigw@mail.gmail.com>
Subject: from mariam kouame
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Dear,

Please grant me permission to share a very crucial discussion with
you. I am looking forward to hearing from you at your earliest
convenience.

Mrs. Mariam Kouame
