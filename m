Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8BAD6EFBCB
	for <lists+kvm-ppc@lfdr.de>; Wed, 26 Apr 2023 22:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239780AbjDZUjM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 26 Apr 2023 16:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239830AbjDZUjK (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 26 Apr 2023 16:39:10 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5906D1BC
        for <kvm-ppc@vger.kernel.org>; Wed, 26 Apr 2023 13:39:06 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-3ef657f5702so53482251cf.3
        for <kvm-ppc@vger.kernel.org>; Wed, 26 Apr 2023 13:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682541545; x=1685133545;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JL3yT3Q33W5/BCQtgOVvz2cK4S2v0dqNTi6RS5aes9g=;
        b=XiB4qeLe8CvFUt1DH+dltO2ewiVPLbXg0/MGZHEMXxL1gLpcslYPmekivqFl2iki/X
         SBvHspjCgD8CedbnCL6smyMpGrpTvTk52EjdwfOeNUDSG8EopsAV8o06YypZMOeZaO0q
         Djxzyg1SwATL+c9cCQzCqoe6kYKaU5E21eBiEaA+LasxOAXKZuVL7ufPtWY82QdVFgYD
         +WDfYLO6n1s0dDGCYe1wUEaw/+C01qHVxxfVFT5kFa1EbM+w6PTaSDqVvUKPqM1aQjd5
         M4it/sv/tmf2yZYKj8Pm8DHEVJERHx49Ej/vpwB/ezOA9aO/F5ld9dKxndHYDvD475Sx
         qBRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682541545; x=1685133545;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JL3yT3Q33W5/BCQtgOVvz2cK4S2v0dqNTi6RS5aes9g=;
        b=FON59O9ZTyGqtmWW8WjxwYOC97doVdwxIpuOsCxdfAFWu5PEnUnZOxkc541kz+frJ5
         nd3KSdZJ6v6WDTrJFMT0OHZ2nLBcuVzYxNMmgEqnF2XQtfadF3Ww0ZPqO/XHFY/5gPp+
         Iz+QStcn43Z4xvwJObkMCWiJZ3Un40XLBLKpoX5wu8rdBUX3u0ZmqYFtn0gRMQC1mB6a
         XpkmGAbzOURpunWCcpzPektVFhnA7awW94WsYbQpT8FECfYy6Xn08vWE/n91PMAQUM/8
         VB2KA5IWeMRiUifLwoi3irnRzDmOUo3h4kKu1l10kqUMqWF7An9HAICUVi+G75aqZZ84
         8vMQ==
X-Gm-Message-State: AAQBX9ewuUnXrhv50cLrEBiDw4996Twiw6Ia/cknqfyBnz5hInvh51EQ
        RjGPxTkv7SKN2/lvCGs6vVEfLumglxqhnWBQ0Uw=
X-Google-Smtp-Source: AKy350ZCB4Uvw0aYts3hKd3aofbVldEJa3ZetIwvKmIYjME1woGhfoUp5Bdf4DFtMfHhP7CLH7XzhPsdbG/mo0HyeOY=
X-Received: by 2002:a05:622a:255:b0:3ec:490b:ce6e with SMTP id
 c21-20020a05622a025500b003ec490bce6emr37203252qtx.48.1682541545413; Wed, 26
 Apr 2023 13:39:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:622a:1391:b0:3b8:6d45:da15 with HTTP; Wed, 26 Apr 2023
 13:39:05 -0700 (PDT)
Reply-To: klassoumark@gmail.com
From:   Mark Klassou <georgerown101@gmail.com>
Date:   Wed, 26 Apr 2023 20:39:05 +0000
Message-ID: <CAHmBb7u4EWdCqYXP-_2=dQw3pDt1y4zDdSMTzmPgCRdo-u-h4w@mail.gmail.com>
Subject: Re
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Good Morning,

I was only wondering if you got my previous email? I have been trying
to reach you by email. Kindly get back to me swiftly, it is very
important.

Yours faithfully
Mark Klassou.
