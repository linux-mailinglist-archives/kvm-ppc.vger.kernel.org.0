Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64F1709605
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 May 2023 13:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjESLPq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 May 2023 07:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjESLPp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 May 2023 07:15:45 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F55CF1
        for <kvm-ppc@vger.kernel.org>; Fri, 19 May 2023 04:15:44 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-510b6a249a8so5469438a12.0
        for <kvm-ppc@vger.kernel.org>; Fri, 19 May 2023 04:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684494943; x=1687086943;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YmxaI1amCfTksu6ynk2557PwK0HJxrBQmYIx/Pz5hBs=;
        b=ezxa8uUWzbE150jYTN2CgYsEJni65a6h3+oJUd5Z9YMAqvN3cmfa7ZeJti8dq+fJzk
         zBkKfk6svJMByPGVx10hdzP3kr9E5qv+kOZnSPwhNnNZjzUaawCwRcdqjySMCI949sw4
         QUjlb/Qy2dM7oL0lmKdQLPpgog/LU2FzzExStXJTprrPZAbIqQiTzQ5C/1iDIbcgxl/+
         en5VmjAB4ty+iHbQ9pjR6Q2fkvBUl+EpRbNJwBzE8FsbsxbV5+aDrKJGR+vtFTy3/47M
         dLTKwq+Rn+fgKSk1uUKQuuvYkwOvuGrZp89gSN78Tzo0482GJeUGPm5B8a7xQAbGWdMh
         bGsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684494943; x=1687086943;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YmxaI1amCfTksu6ynk2557PwK0HJxrBQmYIx/Pz5hBs=;
        b=IqqWaF7nQmAm+362qBdN7Sw6QAem61jflyqN+gTHncEbyOBlCIs+NrGZM4xXeaI0B3
         N5H6XnVkY0/pMa5eO6jZQWXb0PGFN7pb/WJFNfJtF5EcjkUMe23S3rCqa+9rulQdPGMW
         zPm8UNS5UiqpBwZDdS1huM2+zyKEWGO8+/n4++RnLljwizt1O331OlmMTGhQbkfJOy5s
         /Y90NKFg7+lSp4yBwEjzHxNS54AFmBoWjL65Snlmd4dXv+49OOIvc5itRFXh300FgSCy
         2/pYyOtESssH7nO1vURsxK7Ba9oJjWM1L/UnqphMExOtCURKi9nFVXrAjSf9JPSvB6jM
         uI5A==
X-Gm-Message-State: AC+VfDzYsqKLgJzrmUr8Zgw/6yb17S0CoYdrun5pZKmAIrExvuECg2g+
        0NMiJqZRx7B1urhwAgZqZAAaHFCl6UvbCN4xwWE=
X-Google-Smtp-Source: ACHHUZ73Ftvn+mwlvTSp5kDMDNMQPRXyY4wgD6zfnKO1ngvBMUj8HiPrTBVG500jAtuPoVziBDuk+zovBY1mEs/9Ro4=
X-Received: by 2002:a17:906:c152:b0:96a:9c44:86de with SMTP id
 dp18-20020a170906c15200b0096a9c4486demr1550916ejc.64.1684494942768; Fri, 19
 May 2023 04:15:42 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:907:7dab:b0:94f:7d03:8e8b with HTTP; Fri, 19 May 2023
 04:15:42 -0700 (PDT)
Reply-To: ninacoulibaly03@myself.com
From:   nina coulibaly <ninacoulibaly199@gmail.com>
Date:   Fri, 19 May 2023 04:15:42 -0700
Message-ID: <CAM7Z2JBVwWK6vX1URMOnZpvvys-DzhuvmJJmfEL26nieWBRR0g@mail.gmail.com>
Subject: from nina coulibaly
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Dear,

Please grant me permission to share a very crucial discussion with
you. I am looking forward to hearing from you at your earliest
convenience.

Mrs. Nina Coulibal
